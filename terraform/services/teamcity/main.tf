provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    bucket         = "terraform-teamcity-ecs"
    key            = "services/teamcity/terraform.tfstate"
    region         = "eu-north-1"
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
    bucket = var.s3_tf_state_bucket
    key    = "vpc/teamcity/terraform.tfstate"
    region = "eu-north-1"
  }
}

data "terraform_remote_state" "efs" {
  backend = "s3"
  config = {
    bucket = var.s3_tf_state_bucket
    key    = "data-stores/efs/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = var.s3_tf_state_bucket
    key    = "global/iam/terraform.tfstate"
    region = var.region
  }
}

#
# TeamCity server
#
resource "aws_key_pair" "teamcity" {
  key_name   = "teamcity"
  public_key = var.tc_server_public_key
}

module "teamcity_server" {
  source        = "../../modules/services/teamcity_server"
  ami           = "ami-007e30b5b41aba58f"
  instance_type = "t3.medium"
  vpc_id        = data.terraform_remote_state.teamcity_vpc.outputs.vpc_id
  # move to private subnet once everything is tested
  tc_server_subnet_id        = data.terraform_remote_state.teamcity_vpc.outputs.public_subnets[0]
  alb_subnets                = data.terraform_remote_state.teamcity_vpc.outputs.public_subnets
  key_name                   = aws_key_pair.teamcity.key_name
  tc_server_http_port        = 80
  tc_server_version          = "2019.2.4"
  tc_server_instance_profile = data.terraform_remote_state.iam.outputs.tc_server_instance_profile
  efs_id                     = data.terraform_remote_state.efs.outputs.teamcity_efs_id
  efs_sg_id                  = data.terraform_remote_state.efs.outputs.teamcity_efs_sg_id
  efs_dns_name               = data.terraform_remote_state.efs.outputs.teamcity_efs_dns_name
}
