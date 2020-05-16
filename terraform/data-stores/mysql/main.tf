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

resource "aws_db_instance" "teamcity" {
  identifier_prefix   = "terraform-teamcity-ecs"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  name                = "teamcity"
  username            = "admin"
  password            = "password"
}
