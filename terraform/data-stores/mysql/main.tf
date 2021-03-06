provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "data-stores/mysql/terraform.tfstate"
    region = "eu-north-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teamcity-locks"
    encrypt        = true
  }
}

#
# Remote state
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
resource "aws_security_group" "teamcity_database" {
  name        = "teamcity_database"
  description = "TeamCity database"
  vpc_id      = data.terraform_remote_state.teamcity_vpc.outputs.vpc_id
  tags = {
    Name = "teamcity_database"
  }
}

resource "aws_security_group_rule" "allow_traffic_from_vpc" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = concat(data.terraform_remote_state.teamcity_vpc.outputs.private_subnets_cidr_blocks, data.terraform_remote_state.teamcity_vpc.outputs.public_subnets_cidr_blocks)
  security_group_id = aws_security_group.teamcity_database.id
}

resource "aws_security_group_rule" "allow_all_outbound_traffic" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.teamcity_database.id
}

#
# RDS
#
resource "aws_db_subnet_group" "teamcity_database" {
  name       = "teamcity-ecs-subnet-group"
  subnet_ids = data.terraform_remote_state.teamcity_vpc.outputs.private_subnets
}

resource "aws_db_instance" "teamcity_database" {
  identifier_prefix      = "teamcity-ecs"
  engine                 = "mysql"
  allocated_storage      = 10
  instance_class         = "db.t3.micro"
  name                   = "teamcity"
  username               = "admin"
  password               = "password"
  db_subnet_group_name   = aws_db_subnet_group.teamcity_database.id
  vpc_security_group_ids = [aws_security_group.teamcity_database.id]
  # this should be replace with something like
  # final_snapshot_identifier = "teamcity_server_final_snapshot"
  # for production deployment
  skip_final_snapshot = true
}
