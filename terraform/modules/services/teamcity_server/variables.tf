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
  description = "A subnet where TeamCity server can be deployed"
  type        = string
}

variable "tc_server_http_port" {
  description = "TeamCity server HTTP port"
  type        = number
}

variable "vpc_id" {
  description = "A VPC identificator for TeamCity server"
  type        = string
}

variable "alb_subnets" {
  description = "A list of public subnets where ALB should be deployed"
  type        = list
}

variable "key_name" {
  description = "A key name of a Key Pair to use for the instance"
  type        = string
}
