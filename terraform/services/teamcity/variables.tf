variable "region" {
  description = "The AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "s3_tf_state_bucket" {
  description = "The S3 bucket where terraform state is stored"
  type        = string
  default     = "terraform-teamcity-ecs"
}

variable "tc_server_public_key" {
  description = "The SSH key that should be used to connect to TeamCity EC2 server"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzcWAtMR1p/U53G2Wt+9fYbIW6Ijy+kWmcsn8QRaKzlyQfAOrSwGu7Lgiv03vLfbQPI7aUsdawkcvXv9OYdScJV27GgI3cSDYep4NsPwclgZUpet3hb3FfQRxByG3+4v8dVZjhqjqCBmrh7uevyGES+GPXgpoVbIZy7xuiT4AofUU9cFnMR027ohUycZnaAet98uDkTPovTYZ4OiuNh6l11u0KMgzuEe9TllCs/PCKraPKnIVocXSCu6sLbUDSN8R+9TqVHU/PfkHCBdSI/Vs8W7++W6JeT8ATWXA+OeNsT1bdV8LOwd8OTb1XTgtlXlOXxZRtSg0KaZLU2QcUoLrjhQrwIFsjZ4D6rlitHNOhE5Ep4hLt6kCACITAOxs1/+TcJhF6+quTsNzR0ye5JacrR5arpnbd2eLLtdWKfDGVl1KgbGj85IHJkmsfZ/da32qwtk8kRKO5ePdQkThmuz0ZXRX3z3rjhI3veqmVzzGLvQ6CZbSHg3mVSWAocn6KTv0= vkozyrev@MacBook-Pro-Vladimir.local"
}
