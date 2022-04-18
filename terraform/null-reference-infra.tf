# VPCs
resource "aws_vpc" "vpc_nfpmc" {
  cidr_block       = var.vpc_nfpmc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_nfpmc_tag_name
  }
}

# Internet gateways
resource "aws_internet_gateway" "igw_nfpmc" {
  vpc_id = aws_vpc.vpc_nfpmc.id

  tags = {
    Name = var.igw_nfpmc_tag_name
  }
}

# Public subnets
resource "aws_subnet" "subnet_pub_nfpmc" {
  vpc_id            = aws_vpc.vpc_nfpmc.id
  availability_zone = var.subnet_pub_nfpmc_az
  cidr_block        = var.subnet_pub_nfpmc_cidr

  tags = {
    Name = var.subnet_pub_nfpmc_tag_name
  }
}

# Route tables
resource "aws_default_route_table" "rtbl_vpc_nfpmc_default" {
  default_route_table_id = aws_vpc.vpc_nfpmc.default_route_table_id

  tags = {
    Name = var.rtbl_vpc_nfpmc_default_tag_name
  }
}

resource "aws_route_table" "rtbl_pub_nfpmc" {
  vpc_id = aws_vpc.vpc_nfpmc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_nfpmc.id
  }

  tags = {
    Name = var.rtbl_pub_nfpmc_tag_name
  }
}
resource "aws_route_table_association" "rtbl_assoc_public_nfpmc" {
  subnet_id      = aws_subnet.subnet_pub_nfpmc.id
  route_table_id = aws_route_table.rtbl_pub_nfpmc.id
}

# Network ACLs
resource "aws_default_network_acl" "nacl_vpc_nfpmc_default" {
  default_network_acl_id = aws_vpc.vpc_nfpmc.default_network_acl_id

  tags = {
    Name = var.nacl_vpc_nfpmc_default_tag_name
  }
}

resource "aws_network_acl" "nacl_pub_nfpmc" {
  vpc_id = aws_vpc.vpc_nfpmc.id

  dynamic "egress" {
    for_each = [for rule_obj in local.nwaclrules_pub_nfpmc_egress : {
      rule_no    = rule_obj.rule_no
      protocol   = rule_obj.protocol
      icmp_type  = rule_obj.icmp_type
      icmp_code  = rule_obj.icmp_code
      from_port  = rule_obj.from_port
      to_port    = rule_obj.to_port
      cidr_block = rule_obj.cidr_block
      action     = rule_obj.action
    }]
    content {
      rule_no    = egress.value["rule_no"]
      protocol   = egress.value["protocol"]
      icmp_type  = egress.value["icmp_type"]
      icmp_code  = egress.value["icmp_code"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
      cidr_block = egress.value["cidr_block"]
      action     = egress.value["action"]
    }
  }

  dynamic "ingress" {
    for_each = [for rule_obj in local.nwaclrules_pub_nfpmc_ingress : {
      rule_no    = rule_obj.rule_no
      protocol   = rule_obj.protocol
      icmp_type  = rule_obj.icmp_type
      icmp_code  = rule_obj.icmp_code
      from_port  = rule_obj.from_port
      to_port    = rule_obj.to_port
      cidr_block = rule_obj.cidr_block
      action     = rule_obj.action
    }]
    content {
      rule_no    = ingress.value["rule_no"]
      protocol   = ingress.value["protocol"]
      icmp_type  = ingress.value["icmp_type"]
      icmp_code  = ingress.value["icmp_code"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
      cidr_block = ingress.value["cidr_block"]
      action     = ingress.value["action"]
    }
  }

  tags = {
    Name = var.nacl_pub_nfpmc_tag_name
  }
}
resource "aws_network_acl_association" "nacl_assoc_pub_nfpmc" {
  network_acl_id = aws_network_acl.nacl_pub_nfpmc.id
  subnet_id      = aws_subnet.subnet_pub_nfpmc.id
}

# Security Groups
resource "aws_default_security_group" "secgrp_vpc_nfpmc_default" {
  vpc_id = aws_vpc.vpc_nfpmc.id

  tags = {
    Name = var.secgrp_vpc_nfpmc_default_tag_name
  }
}

resource "aws_security_group" "secgrp_pub_nfpmc" {
  vpc_id      = aws_vpc.vpc_nfpmc.id
  name        = var.secgrp_pub_nfpmc_tag_name
  description = var.secgrp_pub_nfpmc_description

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  dynamic "ingress" {
    for_each = [for rule_obj in local.secgrprules_pub_nfpmc_ingress : {
      protocol    = rule_obj.protocol
      from_port   = rule_obj.from_port
      to_port     = rule_obj.to_port
      cidr_blocks = rule_obj.cidr_blocks
      description = rule_obj.description
    }]
    content {
      protocol    = ingress.value["protocol"]
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = ingress.value["cidr_blocks"]
      description = ingress.value["description"]
    }
  }

  tags = {
    Name = var.secgrp_pub_nfpmc_tag_name
  }
}

# Elastic IPs
resource "aws_eip" "eip_nullrefpapermc01" {
  vpc      = true
  instance = aws_instance.ec2_nullrefpapermc01.id

  depends_on = [
    aws_instance.ec2_nullrefpapermc01
  ]
  tags = {
    Name = var.eip_nullrefpapermc01_tag_name
  }
}

# Key pairs
resource "aws_key_pair" "ec2kp_nullrefpapermc01" {
  key_name   = var.ec2kp_nullrefpapermc01_key_name
  public_key = var.ec2kp_nullrefpapermc01_public_key

  tags = {
    Name = var.ec2kp_nullrefpapermc01_key_name
  }
}

# EBS volumes
resource "aws_ebs_volume" "ebs_nullrefpapermc01_data01" {
  availability_zone = var.ec2_nullrefpapermc01_az
  encrypted         = true
  iops              = var.ebs_nullrefpapermc01_data01_iops
  kms_key_id        = var.ebs_nullrefpapermc01_data01_kms_key_id
  size              = var.ebs_nullrefpapermc01_data01_size
  type              = var.ebs_nullrefpapermc01_data01_type
  throughput        = var.ebs_nullrefpapermc01_data01_throughput

  depends_on = [
    aws_instance.ec2_nullrefpapermc01
  ]
  tags = {
    Name = var.ebs_nullrefpapermc01_data01_tag_name
  }
}
resource "aws_volume_attachment" "ebs_attach_nullrefpapermc01_data01" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.ec2_nullrefpapermc01.id
  volume_id   = aws_ebs_volume.ebs_nullrefpapermc01_data01.id
}

# EC2
resource "aws_instance" "ec2_nullrefpapermc01" {
  ami               = var.ec2_nullrefpapermc01_ami
  availability_zone = var.ec2_nullrefpapermc01_az
  instance_type     = var.ec2_nullrefpapermc01_instance_type
  key_name          = var.ec2kp_nullrefpapermc01_key_name
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    iops                  = var.ec2_nullrefpapermc01_rbd_iops
    kms_key_id            = var.ec2_nullrefpapermc01_rbd_kms_key_id
    throughput            = var.ec2_nullrefpapermc01_rbd_throughput
    volume_size           = var.ec2_nullrefpapermc01_rbd_volume_size
    volume_type           = var.ec2_nullrefpapermc01_rbd_volume_type
    tags = {
      Name = var.ec2_nullrefpapermc01_rbd_tag_name
    }
  }
  subnet_id = aws_subnet.subnet_pub_nfpmc.id
  vpc_security_group_ids = [
    aws_security_group.secgrp_pub_nfpmc.id
  ]

  depends_on = [
    aws_key_pair.ec2kp_nullrefpapermc01
  ]
  tags = {
    Name     = var.ec2_nullrefpapermc01_tag_name
    OsDistro = var.ec2_nullrefpapermc01_tag_os_disto
  }
}

# Locally defined variables
locals {
  nwaclrules_pub_nfpmc_egress = [
    { rule_no : 100, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 1024, to_port : 65535, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 200, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 80, to_port : 80, cidr_block : "0.0.0.0/0", action : "allow" },   # Necessary for downloading software
    { rule_no : 201, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 443, to_port : 443, cidr_block : "0.0.0.0/0", action : "allow" }, # Necessary for downloading software
    { rule_no : 300, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 22, to_port : 22, cidr_block : "0.0.0.0/0", action : "deny" }     # Included to act as a 'switch' should the host need to act as an SSH client at some point
  ]
  nwaclrules_pub_nfpmc_ingress = [
    { rule_no : 20, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 22, to_port : 22, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 100, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 25565, to_port : 25565, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 101, protocol : "udp", icmp_type : -1, icmp_code : -1, from_port : 25565, to_port : 25565, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 200, protocol : "tcp", icmp_type : -1, icmp_code : -1, from_port : 1024, to_port : 65535, cidr_block : "0.0.0.0/0", action : "allow" } # Necessary for downloading software
  ]
  # Don't allow inbound SSH at the Security Group level. If SSH access is required then manually create a rule via the console.
  secgrprules_pub_nfpmc_ingress = [
    { protocol : "tcp", from_port : 25565, to_port : 25565, cidr_blocks : ["0.0.0.0/0"], description : "Allow inbound Minecraft client traffic (TCP)" },
    { protocol : "udp", from_port : 25565, to_port : 25565, cidr_blocks : ["0.0.0.0/0"], description : "Allow inbound Minecraft client traffic (UDP)" },
  ]
}
