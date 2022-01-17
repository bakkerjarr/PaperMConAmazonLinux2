#!/bin/bash
#title          : account-cleanup-default-vpcs.sh
#description    : Delete the default VPCs within an AWS account. This script
#                 assumes that a user has already been authenticated using the
#                 AWS CLI.
#author         : Jarrod Bakker
#date           : 29/11/2021
#version        : 0.1.0
#usage          : See disaply_usage() function below.
#history        : 29/01/2021 - jnb - Initial version.
#==============================================================================
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin
export PATH

display_usage() {
    cat <<HELP_USAGE
Usage: $0 -h

Delete the default VPCs within an AWS account. This script assumes that a user
has already been authenticated using the AWS CLI.

Options:
  -h        Display this message and exit
  -i        A comma-separate list of AWS regions for this script to ignore
HELP_USAGE
}

log_info() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` INFO $1"
}

log_critical() {
    echo -e "`date '+%Y-%m-%d %H:%M:%S'` CRITICAL $1"
}

### SANITY CHECKS ###
# Thanks to https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
# for the options parser below!
PARAMS=""
ignore_regions=""
while (( "$#" )); do
    case "$1" in
        -h)
            display_usage
            exit 0
            ;;
        -i)
            IFS=', ' read -r -a ignore_regions <<< "$2"
            shift
            shift
            ;; 
        -*|--*=) # unsupported flags
            echo "Unsupported flag supplied: $1" >&2
            display_usage
            exit 1
            ;;
        *) # preserve positional arguments
            echo "This command does not support positional arguments."
            display_usage
            exit 1
            ;;
    esac
done

# Has the user supplied the correct number of arguments?
[[ $# -ne 0 ]] && display_usage && exit 1

# Check that the AWS CLI v2 tool is installed
if ! command -v aws &> /dev/null; then
    log_critical "The 'aws' command is not installed. Please see
https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html for
instructions on installing this command."
    exit 1
fi
### SANITY CHECKS DONE ###

account_id=`aws sts get-caller-identity --output text | cut -f1`
log_info "This script will cleanup defaults VPCs for account: $account_id"

cleaned_regions=$(aws ec2 describe-regions --output text | cut -f4)
for region in ${ignore_regions[@]}; do
    cleaned_regions=("${cleaned_regions[@]/$region}")
done

for region in $cleaned_regions; do
    log_info "Finding default VPC in region: $region"
    output=$(aws ec2 describe-vpcs --region $region --output yaml)
    if echo "$output" | grep "\[\]" > /dev/null 2>&1; then
        log_info "No VPCs were found in region $region"
        continue
    fi
    is_default=$(echo "$output" | grep IsDefault | awk '{print $2}')
    vpc_id=$(echo "$output" | grep VpcId | awk '{print $2}')
    if [ "$is_default" = "false" ]; then
        log_info "VPC $vpc_id is not a default VPC, skipping..."
        continue
    fi
    # We must clean up resources in a VPC before it can be deleted
    output=$(aws ec2 describe-subnets --region $region --output yaml)
    echo "$output" | grep "Subnets: \[\]" > /dev/null 2>&1
    if [ ${PIPESTATUS[1]} -eq 1 ]; then
        subnet_ids=$(echo "$output" | grep SubnetId | awk '{print $2}')
        for id in $subnet_ids; do
            log_info "Deleting Subnet $id"
            aws ec2 delete-subnet --subnet-id "$id" --region "$region"
        done
    fi

    output=$(aws ec2 describe-dhcp-options --region $region --output yaml)
    echo "$output" | grep "DhcpOptions: \[\]" > /dev/null 2>&1
    if [ ${PIPESTATUS[1]} -eq 1 ]; then
        id=$(echo "$output" | grep DhcpOptionsId | awk '{print $2}')
        log_info "Deleting DHCP Options Set $id"
        aws ec2 associate-dhcp-options --dhcp-options-id default \
            --vpc-id "$vpc_id" --region "$region"
        aws ec2 delete-dhcp-options --dhcp-options-id "$id" --region "$region"
    fi

    output=$(aws ec2 describe-internet-gateways --region $region --output yaml)
    echo "$output" | grep "InternetGateways: \[\]" > /dev/null 2>&1
    if [ ${PIPESTATUS[1]} -eq 1 ]; then
        id=$(echo "$output" | grep InternetGatewayId | awk '{print $2}')
        log_info "Deleting Internet Gateway $id"
        aws ec2 detach-internet-gateway --internet-gateway-id "$id" \
            --vpc-id "$vpc_id" --region "$region"
        aws ec2 delete-internet-gateway --internet-gateway-id "$id" --region "$region"
    fi

    # We can now proceed with deleting the VPC
    log_info "Deleting default VPC $vpc_id"
    aws ec2 delete-vpc --vpc-id "$vpc_id" --region "$region"
done
