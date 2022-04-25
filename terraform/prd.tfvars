# IAM
iampolicy_lambda_ec2_start_stop_description         = "IAM policy to permit AWS Lambda functions to start and stop production Null Reference PaperMC EC2 instances."
iampolicy_lambda_ec2_start_stop_tag_name            = "iampolicy-p-lamba-ec2-start-stop"
iampolicy_attach_iamrole_lambda_ec2_start_stop_name = "iampolicy-p-attach-iamrole-lambda-ec2-start-stop-name"
iamrole_lamba_ec2_start_stop_description            = "IAM role to permit AWS Lambda functions to start and stop production Null Reference PaperMC EC2 instances."
iamrole_lamba_ec2_start_stop_tag_name               = "iamrole-p-lamba-ec2-start-stop"

# VPCs
vpc_nfpmc_cidr     = "10.0.0.0/16"
vpc_nfpmc_tag_name = "vpc-apse2-p-nullrefpapermc"

# Internet gateways
igw_nfpmc_tag_name = "igw-apse2-p-nullrefpapermc"

# Public subnets
subnet_pub_nfpmc_az       = "ap-southeast-2a"
subnet_pub_nfpmc_cidr     = "10.0.0.0/28"
subnet_pub_nfpmc_tag_name = "subnet-apse2-p-pub-nullrefpapermc01"

# Route tables
rtbl_vpc_nfpmc_default_tag_name = "rtbl-apse2-p-vpc-nfpmc-default"
rtbl_pub_nfpmc_tag_name         = "rtbl-apse2-p-pub-nfpmc"

# Network ACLs
nacl_vpc_nfpmc_default_tag_name = "nacl-apse2-p-vpc-nfpmc-default"
nacl_pub_nfpmc_tag_name         = "nacl-apse2-p-pub-nullrefpapermc01"

# Security Groups
secgrp_vpc_nfpmc_default_tag_name = "secgrp-apse2-p-vpc-nfpmc-default"
secgrp_pub_nfpmc_tag_name         = "secgrp-apse2-p-nullrefpapermc01"
secgrp_pub_nfpmc_description      = "Permit incoming traffic to the Null Reference PaperMC server."

# Elastic IPs
eip_nullrefpapermc01_tag_name = "ec2-apse2-p-nullrefpapermc01"

# Key pairs
ec2kp_nullrefpapermc01_key_name   = "ec2kp-apse2-p-nullrefpapermc01"
ec2kp_nullrefpapermc01_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGsmqbYpRYA5nmH8tWwovHoniXbxg1DKSwvvQ6ankCK jarrodbakkernfpmc"

# EBS volumes
ebs_nullrefpapermc01_data01_iops       = "3000"
ebs_nullrefpapermc01_data01_kms_key_id = "arn:aws:kms:ap-southeast-2:536334314727:key/faec0620-c76a-401b-aab6-cd755300a42c"
ebs_nullrefpapermc01_data01_size       = "50"
ebs_nullrefpapermc01_data01_type       = "gp3"
ebs_nullrefpapermc01_data01_throughput = "125"
ebs_nullrefpapermc01_data01_tag_name   = "ebs-apse2-p-nullrefpapermc01-data01"

# EC2
ec2_nullrefpapermc01_ami                   = "ami-059af0b76ba105e7e" # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type (64-bit x86)
ec2_nullrefpapermc01_az                    = "ap-southeast-2a"
ec2_nullrefpapermc01_instance_type         = "t3.small"
ec2_nullrefpapermc01_rbd_iops              = "3000"
ec2_nullrefpapermc01_rbd_kms_key_id        = "arn:aws:kms:ap-southeast-2:536334314727:key/faec0620-c76a-401b-aab6-cd755300a42c"
ec2_nullrefpapermc01_rbd_tag_name          = "ebs-apse2-p-nullrefpapermc01-root-block-device"
ec2_nullrefpapermc01_rbd_throughput        = "125"
ec2_nullrefpapermc01_rbd_volume_size       = "10"
ec2_nullrefpapermc01_rbd_volume_type       = "gp3"
ec2_nullrefpapermc01_tag_name              = "ec2-apse2-p-nullrefpapermc01"
ec2_nullrefpapermc01_tag_lambda_nfpmc_auto = "true"
ec2_nullrefpapermc01_tag_os_disto          = "AmazonLinux2"

# Lambda
lambda_nfpmc_ec2_start_env_key    = "LambdaNfpmcAuto"
lambda_nfpmc_ec2_start_env_value  = "true"
lambda_nfpmc_ec2_start_env_region = "ap-southeast-2"
lambda_nfpmc_ec2_start_runtime    = "python3.9"
lambda_nfpmc_ec2_start_tag_name   = "lambda-apse2-p-nfpmc-ec2-start"
lambda_nfpmc_ec2_stop_env_key     = "LambdaNfpmcAuto"
lambda_nfpmc_ec2_stop_env_value   = "true"
lambda_nfpmc_ec2_stop_env_region  = "ap-southeast-2"
lambda_nfpmc_ec2_stop_runtime     = "python3.9"
lambda_nfpmc_ec2_stop_tag_name    = "lambda-apse2-p-nfpmc-ec2-stop"
