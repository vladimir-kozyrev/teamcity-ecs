variable "ami" {
  description = "An AMI that will be used to create TeamCity server EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "tc_server_subnet_id" {
  description = "The subnet where TeamCity server can be deployed"
  type        = string
}

variable "tc_server_http_port" {
  description = "The TeamCity server HTTP port"
  type        = number
}

variable "tc_server_version" {
  description = "The TeamCity server version to run"
  type        = string
}

variable "tc_server_instance_profile" {
  description = "The TeamCity IAM instance profile"
  type        = string
}

variable "vpc_id" {
  description = "The VPC identificator for TeamCity server"
  type        = string
}

variable "alb_subnets" {
  description = "The list of public subnets where ALB should be deployed"
  type        = list
}

variable "key_name" {
  description = "The key name of a Key Pair to use for the instance"
  type        = string
}

variable "efs_id" {
  description = "The EFS id that should be available for TC server"
  type        = string
}

variable "efs_sg_id" {
  description = "The EFS security group ID"
  type        = string
}

variable "efs_dns_name" {
  description = "The DNS name of EFS that will be used as data store for TeamCity server"
  type        = string
}
