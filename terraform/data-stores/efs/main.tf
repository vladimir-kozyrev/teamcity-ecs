provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "data-stores/efs/terraform.tfstate"
    region = "eu-north-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teamcity-locks"
    encrypt        = true
  }
}

#
# Remote states
#
data "terraform_remote_state" "teamcity_vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "vpc/teamcity/terraform.tfstate"
    region = "eu-north-1"
  }
}

#
# Security groups
#
resource "aws_security_group" "efs" {
  name        = "efs"
  description = "Allow traffic from VPC subnets"
  vpc_id      = data.terraform_remote_state.teamcity_vpc.outputs.vpc_id
  tags = {
    Name = "efs"
  }
}

resource "aws_security_group_rule" "allow_traffic_from_vpc" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = concat(data.terraform_remote_state.teamcity_vpc.outputs.private_subnets_cidr_blocks, data.terraform_remote_state.teamcity_vpc.outputs.public_subnets_cidr_blocks)
  security_group_id = aws_security_group.efs.id
}

resource "aws_security_group_rule" "allow_all_outbound_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.efs.id
}

#
# EFS
#
resource "aws_efs_file_system" "teamcity_server" {
  creation_token = "teamcity_server"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}
