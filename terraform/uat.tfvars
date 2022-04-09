# VPCs
vpc_nfpmc_cidr     = "10.0.0.0/16"
vpc_nfpmc_tag_name = "vpc-apse2-u-nullrefpapermc"

# Internet gateways
igw_nfpmc_tag_name = "igw-apse2-u-nullrefpapermc"

# Public subnets
subnet_pub_nfpmc_az       = "ap-southeast-2a"
subnet_pub_nfpmc_cidr     = "10.0.0.0/28"
subnet_pub_nfpmc_tag_name = "subnet-pub-apse2-u-nullrefpapermc01"

# Route tables
rtbl_vpc_nfpmc_default_tag_name = "rtbl-apse2-u-vpc-nfpmc-default"
rtbl_pub_nfpmc_tag_name         = "rtbl-apse2-u-pub-nfpmc"

# Network ACLs
nacl_vpc_nfpmc_default_tag_name = "nacl-apse2-u-vpc-nfpmc-default"
nacl_pub_nfpmc_tag_name         = "nacl-apse2-u-pub-nfpmc"

# Security Groups
secgrp_vpc_nfpmc_default_tag_name = "secgrp-apse2-u-vpc-nfpmc-default"
secgrp_pub_nfpmc_tag_name         = "secgrp-apse2-u-nfpmc-default"
secgrp_pub_nfpmc_description      = "Permit incoming traffic to the Null Reference PaperMC server."

# Elastic IPs
eip_nullrefpapermc01_tag_name = "ec2-apse2-u-nullrefpapermc01"

# Key pairs
ec2kp_nullrefpapermc01_key_name   = "ec2kp-apse2-u-nullrefpapermc01"
ec2kp_nullrefpapermc01_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGsmqbYpRYA5nmH8tWwovHoniXbxg1DKSwvvQ6ankCK jarrodbakkernfpmc"

# EBS volumes
ebs_nullrefpapermc01_data01_iops       = "3000"
ebs_nullrefpapermc01_data01_kms_key_id = "arn:aws:kms:ap-southeast-2:536334314727:key/faec0620-c76a-401b-aab6-cd755300a42c"
ebs_nullrefpapermc01_data01_size       = "10"
ebs_nullrefpapermc01_data01_type       = "gp3"
ebs_nullrefpapermc01_data01_throughput = "125"
ebs_nullrefpapermc01_data01_tag_name   = "ebs-apse2-u-nullrefpapermc01-data01"

# EC2
ec2_nullrefpapermc01_ami             = "ami-059af0b76ba105e7e" # Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type (64-bit x86)
ec2_nullrefpapermc01_az              = "ap-southeast-2a"
ec2_nullrefpapermc01_instance_type   = "t3.micro"
ec2_nullrefpapermc01_rbd_iops        = "3000"
ec2_nullrefpapermc01_rbd_kms_key_id  = "arn:aws:kms:ap-southeast-2:536334314727:key/faec0620-c76a-401b-aab6-cd755300a42c"
ec2_nullrefpapermc01_rbd_tag_name    = "ebs-apse2-u-nullrefpapermc01-root-block-device"
ec2_nullrefpapermc01_rbd_throughput  = "125"
ec2_nullrefpapermc01_rbd_volume_size = "10"
ec2_nullrefpapermc01_rbd_volume_type = "gp3"
ec2_nullrefpapermc01_tag_name        = "ec2-apse2-u-nullrefpapermc01"
ec2_nullrefpapermc01_tag_os_disto    = "AmazonLinux2"
