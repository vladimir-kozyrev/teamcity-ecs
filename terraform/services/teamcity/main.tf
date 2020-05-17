provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "services/teamcity/terraform.tfstate"
    region = "eu-north-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teamcity-locks"
    encrypt        = true
  }
}

data "terraform_remote_state" "teamcity_db" {
  backend = "s3"
  config = {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "data-stores/mysql/terraform.tfstate"
    region = "eu-north-1"
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

resource "aws_key_pair" "teamcity" {
  key_name   = "teamcity"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzcWAtMR1p/U53G2Wt+9fYbIW6Ijy+kWmcsn8QRaKzlyQfAOrSwGu7Lgiv03vLfbQPI7aUsdawkcvXv9OYdScJV27GgI3cSDYep4NsPwclgZUpet3hb3FfQRxByG3+4v8dVZjhqjqCBmrh7uevyGES+GPXgpoVbIZy7xuiT4AofUU9cFnMR027ohUycZnaAet98uDkTPovTYZ4OiuNh6l11u0KMgzuEe9TllCs/PCKraPKnIVocXSCu6sLbUDSN8R+9TqVHU/PfkHCBdSI/Vs8W7++W6JeT8ATWXA+OeNsT1bdV8LOwd8OTb1XTgtlXlOXxZRtSg0KaZLU2QcUoLrjhQrwIFsjZ4D6rlitHNOhE5Ep4hLt6kCACITAOxs1/+TcJhF6+quTsNzR0ye5JacrR5arpnbd2eLLtdWKfDGVl1KgbGj85IHJkmsfZ/da32qwtk8kRKO5ePdQkThmuz0ZXRX3z3rjhI3veqmVzzGLvQ6CZbSHg3mVSWAocn6KTv0= vkozyrev@MacBook-Pro-Vladimir.local"
}

module "teamcity_server" {
  source              = "../../modules/services/teamcity_server"
  ami                 = "ami-007e30b5b41aba58f"
  instance_type       = "t3.small"
  vpc_id              = data.terraform_remote_state.teamcity_vpc.outputs.vpc_id
  # move to private subnet once everything is tested
  tc_server_subnet_id = data.terraform_remote_state.teamcity_vpc.outputs.public_subnets[0]
  alb_subnets         = data.terraform_remote_state.teamcity_vpc.outputs.public_subnets
  key_name            = aws_key_pair.teamcity.key_name
  tc_server_http_port = 80
}
