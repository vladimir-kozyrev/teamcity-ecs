#
# ALB
#
resource "aws_security_group" "teamcity_server_alb" {
  name        = "teamcity_server_alb"
  description = "Allow HTTPS traffic to TeamCity ALB"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow HTTP traffic to TeamCity ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "teamcity_server_alb"
  }
}

# https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/5.0.0
module "teamcity_server_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"
  name = "teamcity-server-alb"
  load_balancer_type = "application"
  vpc_id          = var.vpc_id
  subnets         = var.alb_subnets
  security_groups = [aws_security_group.teamcity_server_alb.id]
  target_groups = [
    {
      name_prefix      = "ts"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]
  http_tcp_listeners = [
    {
      port               = var.tc_server_http_port
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]
}

resource "aws_lb_target_group_attachment" "teamcity_alb_to_ec2" {
  target_group_arn = module.teamcity_server_alb.target_group_arns[0]
  target_id        = aws_instance.teamcity_server.id
  port             = var.tc_server_http_port
}

#
# EFS
#
resource "aws_security_group" "efs" {
  name        = "efs"
  description = "Allow traffic from everywhere"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow traffic from everywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "efs"
  }
}

resource "aws_efs_file_system" "teamcity_server" {
  creation_token = "teamcity_server"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "teamcity_server" {
  file_system_id  = aws_efs_file_system.teamcity_server.id
  subnet_id       = var.tc_server_subnet_id
  security_groups = [aws_security_group.efs.id]
}

#
# TeamCity server EC2
#
resource "aws_security_group" "teamcity_server" {
  name        = "teamcity_server"
  description = "Allow HTTP traffic from TeamCity ALB"
  vpc_id      = var.vpc_id
  ingress {
    description     = "Allow HTTP traffic from TeamCity ALB"
    from_port       = var.tc_server_http_port
    to_port         = var.tc_server_http_port
    protocol        = "tcp"
    security_groups = [aws_security_group.teamcity_server_alb.id]
  }
  ingress {
    description = "Allow SSH traffic from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "teamcity_server"
  }
}

resource "aws_instance" "teamcity_server" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.tc_server_subnet_id
  security_groups = [aws_security_group.teamcity_server.id]
  key_name        = var.key_name
  root_block_device {
    volume_type = "gp2"
    volume_size = 12
  }
  tags = {
    Name = "teamcity_server"
  }
  user_data = <<EOF
#!/bin/bash -xe
TEAMCITY_DIR=/teamcity
sudo mkdir -v $TEAMCITY_DIR
sudo mount \
  -t nfs \
  -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport \
  ${aws_efs_file_system.teamcity_server.dns_name}:/ \
  $TEAMCITY_DIR
sudo chmod -v go+rw $TEAMCITY_DIR
sudo docker run -d \
  --name teamcity-server \
  -v $TEAMCITY_DIR/logs:/opt/teamcity/logs \
  -v $TEAMCITY_DIR/datadir:/data/teamcity_server/datadir \
  -p ${var.tc_server_http_port}:8111 \
  jetbrains/teamcity-server:2019.2.4
EOF
}
