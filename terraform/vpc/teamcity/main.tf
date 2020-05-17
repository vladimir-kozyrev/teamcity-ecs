provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "vpc/teamcity/terraform.tfstate"
    region = "eu-north-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teamcity-locks"
    encrypt        = true
  }
}

# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.33.0
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "2.33.0"
  name                 = "teamcity-ecs"
  cidr                 = "10.0.0.0/16"
  azs                  = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
