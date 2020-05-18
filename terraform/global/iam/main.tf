provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.62"
}

terraform {
  backend "s3" {
    # Replace this with your bucket name!
    bucket = "terraform-teamcity-ecs"
    key    = "global/iam/terraform.tfstate"
    region = "eu-north-1"
    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-teamcity-locks"
    encrypt        = true
  }
}

#
# IAM
#
resource "aws_iam_role" "teamcity_server" {
  name               = "teamcity_server"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "teamcity_server" {
  name = "teamcity_server"
  role = aws_iam_role.teamcity_server.name
}

resource "aws_iam_role_policy" "teamcity_server" {
  name   = "teamcity_server"
  role   = aws_iam_role.teamcity_server.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "TeamCityServerECS",
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "ecs:DescribeClusters",
        "ecs:DescribeTaskDefinition",
        "ecs:DescribeTasks",
        "ecs:ListClusters",
        "ecs:ListTaskDefinitions",
        "ecs:ListTasks",
        "ecs:RunTask",
        "ecs:StopTask",
        "cloudwatch:GetMetricStatistics"
      ]
    }
  ]
}
EOF
}
