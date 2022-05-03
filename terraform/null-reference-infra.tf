# IAM
resource "aws_iam_policy" "iampolicy_lambda_ec2_start_stop" {
  name        = var.iampolicy_lambda_ec2_start_stop_tag_name
  description = var.iampolicy_lambda_ec2_start_stop_description

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances"
        ]
        Resource = "*"
      },
      {
        Sid    = "VisualEditor1"
        Effect = "Allow"
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "arn:aws:ec2:*:536334314727:instance/*"
      },
    ]
  })

  tags = {
    Name = var.iampolicy_lambda_ec2_start_stop_tag_name
  }
}
resource "aws_iam_role" "iamrole_lambda_ec2_start_stop" {
  name        = var.iamrole_lamba_ec2_start_stop_tag_name
  description = var.iamrole_lamba_ec2_start_stop_description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "VisualEditor0"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = var.iamrole_lamba_ec2_start_stop_tag_name
  }
}
resource "aws_iam_policy_attachment" "iampolicy_attach_iamrole_lambda_ec2_start_stop" {
  name       = var.iampolicy_attach_iamrole_lambda_ec2_start_stop_name
  roles      = [aws_iam_role.iamrole_lambda_ec2_start_stop.name]
  policy_arn = aws_iam_policy.iampolicy_lambda_ec2_start_stop.arn
}

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
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
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
    Name            = var.ec2_nullrefpapermc01_tag_name
    OsDistro        = var.ec2_nullrefpapermc01_tag_os_disto
    LambdaNfpmcAuto = var.ec2_nullrefpapermc01_tag_lambda_nfpmc_auto
  }
}

# Lambda
data "archive_file" "lambda_nfpmc_ec2_start" {
  type        = "zip"
  source_file = "${path.module}/aws_lambda/lambda_nfpmc_ec2_start.py"
  output_path = "${path.module}/aws_lambda/zips/lambda_nfpmc_ec2_start.zip"
}

data "archive_file" "lambda_nfpmc_ec2_stop" {
  type        = "zip"
  source_file = "${path.module}/aws_lambda/lambda_nfpmc_ec2_stop.py"
  output_path = "${path.module}/aws_lambda/zips/lambda_nfpmc_ec2_stop.zip"
}

resource "aws_lambda_function" "lambda_nfpmc_ec2_start" {
  architectures = ["x86_64"]
  environment {
    variables = {
      KEY    = var.lambda_nfpmc_ec2_start_env_key
      VALUE  = var.lambda_nfpmc_ec2_start_env_value
      REGION = var.lambda_nfpmc_ec2_start_env_region
    }
  }
  filename         = "${path.module}/aws_lambda/zips/lambda_nfpmc_ec2_start.zip"
  function_name    = var.lambda_nfpmc_ec2_start_tag_name
  handler          = "lambda_nfpmc_ec2_start.lambda_handler"
  role             = aws_iam_role.iamrole_lambda_ec2_start_stop.arn
  runtime          = var.lambda_nfpmc_ec2_start_runtime
  source_code_hash = data.archive_file.lambda_nfpmc_ec2_start.output_base64sha256

  depends_on = [
    aws_iam_policy_attachment.iampolicy_attach_iamrole_lambda_ec2_start_stop,
    data.archive_file.lambda_nfpmc_ec2_start
  ]
  tags = {
    Name = var.lambda_nfpmc_ec2_start_tag_name
  }
}

resource "aws_lambda_function" "lambda_nfpmc_ec2_stop" {
  architectures = ["x86_64"]
  environment {
    variables = {
      KEY    = var.lambda_nfpmc_ec2_stop_env_key
      VALUE  = var.lambda_nfpmc_ec2_stop_env_value
      REGION = var.lambda_nfpmc_ec2_stop_env_region
    }
  }
  filename         = "${path.module}/aws_lambda/zips/lambda_nfpmc_ec2_stop.zip"
  function_name    = var.lambda_nfpmc_ec2_stop_tag_name
  handler          = "lambda_nfpmc_ec2_stop.lambda_handler"
  role             = aws_iam_role.iamrole_lambda_ec2_start_stop.arn
  runtime          = var.lambda_nfpmc_ec2_stop_runtime
  source_code_hash = data.archive_file.lambda_nfpmc_ec2_stop.output_base64sha256

  depends_on = [
    aws_iam_policy_attachment.iampolicy_attach_iamrole_lambda_ec2_start_stop,
    data.archive_file.lambda_nfpmc_ec2_stop
  ]
  tags = {
    Name = var.lambda_nfpmc_ec2_stop_tag_name
  }
}

# EventBridge
resource "aws_cloudwatch_event_rule" "evntbrdgrule_lambda_nfpmc_ec2_start_monthu" {
  name                = var.evntbrdgrule_lambda_nfpmc_ec2_start_monthu_tag_name
  description         = var.evntbrdgrule_lambda_nfpmc_ec2_start_monthu_description
  schedule_expression = var.evntbrdgrule_lambda_nfpmc_ec2_start_monthu_sch_exp
  event_bus_name      = "default"
  is_enabled          = "true"

  tags = {
    Name = var.evntbrdgrule_lambda_nfpmc_ec2_start_monthu_tag_name
  }
}
resource "aws_cloudwatch_event_target" "evnrbrdgtarget_lambda_nfpmc_ec2_start_monthu" {
  rule           = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_start_monthu.name
  arn            = aws_lambda_function.lambda_nfpmc_ec2_start.arn
  event_bus_name = "default"
  target_id      = var.evnrbrdgtarget_lambda_nfpmc_ec2_start_monthu_target_id
}
resource "aws_lambda_permission" "lambdaperm_evntbrdgrule_lambda_nfpmc_ec2_start_monthu" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_nfpmc_ec2_start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_start_monthu.arn
  statement_id  = "lambdaperm_${var.evntbrdgrule_lambda_nfpmc_ec2_start_monthu_tag_name}"
}

resource "aws_cloudwatch_event_rule" "evntbrdgrule_lambda_nfpmc_ec2_start_fri" {
  name                = var.evntbrdgrule_lambda_nfpmc_ec2_start_fri_tag_name
  description         = var.evntbrdgrule_lambda_nfpmc_ec2_start_fri_description
  schedule_expression = var.evntbrdgrule_lambda_nfpmc_ec2_start_fri_sch_exp
  event_bus_name      = "default"
  is_enabled          = "true"

  tags = {
    Name = var.evntbrdgrule_lambda_nfpmc_ec2_start_fri_tag_name
  }
}
resource "aws_cloudwatch_event_target" "evnrbrdgtarget_lambda_nfpmc_ec2_start_fri" {
  rule           = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_start_fri.name
  arn            = aws_lambda_function.lambda_nfpmc_ec2_start.arn
  event_bus_name = "default"
  target_id      = var.evnrbrdgtarget_lambda_nfpmc_ec2_start_fri_target_id
}
resource "aws_lambda_permission" "lambdaperm_evntbrdgrule_lambda_nfpmc_ec2_start_fri" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_nfpmc_ec2_start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_start_fri.arn
  statement_id  = "lambdaperm_${var.evntbrdgrule_lambda_nfpmc_ec2_start_fri_tag_name}"
}

resource "aws_cloudwatch_event_rule" "evntbrdgrule_lambda_nfpmc_ec2_start_satsun" {
  name                = var.evntbrdgrule_lambda_nfpmc_ec2_start_satsun_tag_name
  description         = var.evntbrdgrule_lambda_nfpmc_ec2_start_satsun_description
  schedule_expression = var.evntbrdgrule_lambda_nfpmc_ec2_start_satsun_sch_exp
  event_bus_name      = "default"
  is_enabled          = "true"

  tags = {
    Name = var.evntbrdgrule_lambda_nfpmc_ec2_start_satsun_tag_name
  }
}
resource "aws_cloudwatch_event_target" "evnrbrdgtarget_lambda_nfpmc_ec2_start_satsun" {
  rule           = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_start_satsun.name
  arn            = aws_lambda_function.lambda_nfpmc_ec2_start.arn
  event_bus_name = "default"
  target_id      = var.evnrbrdgtarget_lambda_nfpmc_ec2_start_satsun_target_id
}
resource "aws_lambda_permission" "lambdaperm_evntbrdgrule_lambda_nfpmc_ec2_start_satsun" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_nfpmc_ec2_start.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_start_satsun.arn
  statement_id  = "lambdaperm_${var.evntbrdgrule_lambda_nfpmc_ec2_start_satsun_tag_name}"
}

resource "aws_cloudwatch_event_rule" "evntbrdgrule_lambda_nfpmc_ec2_stop_monthu" {
  name                = var.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu_tag_name
  description         = var.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu_description
  schedule_expression = var.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu_sch_exp
  event_bus_name      = "default"
  is_enabled          = "true"

  tags = {
    Name = var.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu_tag_name
  }
}
resource "aws_cloudwatch_event_target" "evnrbrdgtarget_lambda_nfpmc_ec2_stop_monthu" {
  rule           = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu.name
  arn            = aws_lambda_function.lambda_nfpmc_ec2_stop.arn
  event_bus_name = "default"
  target_id      = var.evnrbrdgtarget_lambda_nfpmc_ec2_stop_monthu_target_id
}
resource "aws_lambda_permission" "lambdaperm_evntbrdgrule_lambda_nfpmc_ec2_stop_monthu" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_nfpmc_ec2_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu.arn
  statement_id  = "lambdaperm_${var.evntbrdgrule_lambda_nfpmc_ec2_stop_monthu_tag_name}"
}

resource "aws_cloudwatch_event_rule" "evntbrdgrule_lambda_nfpmc_ec2_stop_fri" {
  name                = var.evntbrdgrule_lambda_nfpmc_ec2_stop_fri_tag_name
  description         = var.evntbrdgrule_lambda_nfpmc_ec2_stop_fri_description
  schedule_expression = var.evntbrdgrule_lambda_nfpmc_ec2_stop_fri_sch_exp
  event_bus_name      = "default"
  is_enabled          = "true"

  tags = {
    Name = var.evntbrdgrule_lambda_nfpmc_ec2_stop_fri_tag_name
  }
}
resource "aws_cloudwatch_event_target" "evnrbrdgtarget_lambda_nfpmc_ec2_stop_fri" {
  rule           = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_stop_fri.name
  arn            = aws_lambda_function.lambda_nfpmc_ec2_stop.arn
  event_bus_name = "default"
  target_id      = var.evnrbrdgtarget_lambda_nfpmc_ec2_stop_fri_target_id
}
resource "aws_lambda_permission" "lambdaperm_evntbrdgrule_lambda_nfpmc_ec2_stop_fri" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_nfpmc_ec2_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_stop_fri.arn
  statement_id  = "lambdaperm_${var.evntbrdgrule_lambda_nfpmc_ec2_stop_fri_tag_name}"
}

resource "aws_cloudwatch_event_rule" "evntbrdgrule_lambda_nfpmc_ec2_stop_satsun" {
  name                = var.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun_tag_name
  description         = var.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun_description
  schedule_expression = var.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun_sch_exp
  event_bus_name      = "default"
  is_enabled          = "true"

  tags = {
    Name = var.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun_tag_name
  }
}
resource "aws_cloudwatch_event_target" "evnrbrdgtarget_lambda_nfpmc_ec2_stop_satsun" {
  rule           = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun.name
  arn            = aws_lambda_function.lambda_nfpmc_ec2_stop.arn
  event_bus_name = "default"
  target_id      = var.evnrbrdgtarget_lambda_nfpmc_ec2_stop_satsun_target_id
}
resource "aws_lambda_permission" "lambdaperm_evntbrdgrule_lambda_nfpmc_ec2_stop_satsun" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_nfpmc_ec2_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun.arn
  statement_id  = "lambdaperm_${var.evntbrdgrule_lambda_nfpmc_ec2_stop_satsun_tag_name}"
}

# Locally defined variables
locals {
  nwaclrules_pub_nfpmc_egress = [
    { rule_no : 100, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 1024, to_port : 65535, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 200, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 80, to_port : 80, cidr_block : "0.0.0.0/0", action : "allow" },   # Necessary for downloading software
    { rule_no : 201, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 443, to_port : 443, cidr_block : "0.0.0.0/0", action : "allow" }, # Necessary for downloading software
    { rule_no : 300, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 22, to_port : 22, cidr_block : "0.0.0.0/0", action : "deny" }     # Included to act as a 'switch' should the host need to act as an SSH client at some point
  ]
  nwaclrules_pub_nfpmc_ingress = [
    { rule_no : 20, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 22, to_port : 22, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 100, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 25565, to_port : 25565, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 101, protocol : "udp", icmp_type : 0, icmp_code : 0, from_port : 25565, to_port : 25565, cidr_block : "0.0.0.0/0", action : "allow" },
    { rule_no : 200, protocol : "tcp", icmp_type : 0, icmp_code : 0, from_port : 1024, to_port : 65535, cidr_block : "0.0.0.0/0", action : "allow" } # Necessary for downloading software
  ]
  # Don't allow inbound SSH at the Security Group level. If SSH access is required then manually create a rule via the console.
  secgrprules_pub_nfpmc_ingress = [
    { protocol : "tcp", from_port : 25565, to_port : 25565, cidr_blocks : ["0.0.0.0/0"], description : "Allow inbound Minecraft client traffic (TCP)" },
    { protocol : "udp", from_port : 25565, to_port : 25565, cidr_blocks : ["0.0.0.0/0"], description : "Allow inbound Minecraft client traffic (UDP)" },
  ]
}
