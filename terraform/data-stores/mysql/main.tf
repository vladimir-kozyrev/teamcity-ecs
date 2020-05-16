provider "aws" {
  region = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "terraform-teamcity-ecs"
    key            = "data-stores/mysql/terraform.tfstate"
    region         = "eu-north-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teamcity-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "teamcity_vpc" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "vpc/teamcity/terraform.tfstate"
    region = "eu-north-1"
  }
}

resource "aws_db_subnet_group" "teamcity" {
  name       = "teamcity-ecs-subnet-group"
  subnet_ids = data.terraform_remote_state.teamcity_vpc.outputs.private_subnets
}

resource "aws_db_instance" "teamcity" {
  identifier_prefix    = "terraform-teamcity-ecs"
  engine               = "mysql"
  allocated_storage    = 10
  instance_class       = "db.t3.micro"
  name                 = "teamcity"
  username             = "admin"
  password             = "password"
  db_subnet_group_name = aws_db_subnet_group.teamcity.id
}
