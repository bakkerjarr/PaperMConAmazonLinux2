# IAM
variable "iampolicy_lambda_ec2_start_stop_description" { type = string }
variable "iampolicy_lambda_ec2_start_stop_tag_name" { type = string }
variable "iampolicy_attach_iamrole_lambda_ec2_start_stop_name" { type = string }
variable "iamrole_lamba_ec2_start_stop_description" { type = string }
variable "iamrole_lamba_ec2_start_stop_tag_name" { type = string }

# VPCs
variable "vpc_nfpmc_cidr" { type = string }
variable "vpc_nfpmc_tag_name" { type = string }

# Internet gateways
variable "igw_nfpmc_tag_name" { type = string }

# Public subnets
variable "subnet_pub_nfpmc_az" { type = string }
variable "subnet_pub_nfpmc_cidr" { type = string }
variable "subnet_pub_nfpmc_tag_name" { type = string }

# Route tables
variable "rtbl_vpc_nfpmc_default_tag_name" { type = string }
variable "rtbl_pub_nfpmc_tag_name" { type = string }

# Network ACLs
variable "nacl_vpc_nfpmc_default_tag_name" { type = string }
variable "nacl_pub_nfpmc_tag_name" { type = string }

# Security Groups
variable "secgrp_vpc_nfpmc_default_tag_name" { type = string }
variable "secgrp_pub_nfpmc_tag_name" { type = string }
variable "secgrp_pub_nfpmc_description" { type = string }

# Elastic IPs
variable "eip_nullrefpapermc01_tag_name" { type = string }

# Key pairs
variable "ec2kp_nullrefpapermc01_key_name" { type = string }
variable "ec2kp_nullrefpapermc01_public_key" { type = string }

# EBS volumes
variable "ebs_nullrefpapermc01_data01_iops" { type = string }
variable "ebs_nullrefpapermc01_data01_kms_key_id" { type = string }
variable "ebs_nullrefpapermc01_data01_size" { type = string }
variable "ebs_nullrefpapermc01_data01_type" { type = string }
variable "ebs_nullrefpapermc01_data01_throughput" { type = string }
variable "ebs_nullrefpapermc01_data01_tag_name" { type = string }

# EC2
variable "ec2_nullrefpapermc01_ami" { type = string }
variable "ec2_nullrefpapermc01_az" { type = string }
variable "ec2_nullrefpapermc01_instance_type" { type = string }
variable "ec2_nullrefpapermc01_rbd_iops" { type = string }
variable "ec2_nullrefpapermc01_rbd_kms_key_id" { type = string }
variable "ec2_nullrefpapermc01_rbd_tag_name" { type = string }
variable "ec2_nullrefpapermc01_rbd_throughput" { type = string }
variable "ec2_nullrefpapermc01_rbd_volume_size" { type = string }
variable "ec2_nullrefpapermc01_rbd_volume_type" { type = string }
variable "ec2_nullrefpapermc01_tag_name" { type = string }
variable "ec2_nullrefpapermc01_tag_lambda_nfpmc_auto" { type = string }
variable "ec2_nullrefpapermc01_tag_os_disto" { type = string }

# Lambda
variable "lambda_nfpmc_ec2_start_env_key" { type = string }
variable "lambda_nfpmc_ec2_start_env_value" { type = string }
variable "lambda_nfpmc_ec2_start_env_region" { type = string }
variable "lambda_nfpmc_ec2_start_runtime" { type = string }
variable "lambda_nfpmc_ec2_start_tag_name" { type = string }
variable "lambda_nfpmc_ec2_stop_env_key" { type = string }
variable "lambda_nfpmc_ec2_stop_env_value" { type = string }
variable "lambda_nfpmc_ec2_stop_env_region" { type = string }
variable "lambda_nfpmc_ec2_stop_runtime" { type = string }
variable "lambda_nfpmc_ec2_stop_tag_name" { type = string }
