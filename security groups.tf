# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name   = var.alb_sg_name
  vpc_id = module.vpc.vpc_id

  #Allow HTTP from anywhere
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.tcp_proctocol
    cidr_blocks = var.all_cidr_block
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = var.alb_sg_name
  })
}

# ECS app security group 
resource "aws_security_group" "ecs_sg" {
  name   = var.ecs_sg_name
  vpc_id = module.vpc.vpc_id

  # HTTP access from ALB
  ingress {
    from_port       = var.http_port
    to_port         = var.http_port
    protocol        = var.tcp_proctocol
    security_groups = [aws_security_group.alb_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = var.ecs_sg_name
  })
}

# RDS mysql security group 
resource "aws_security_group" "rds_sg" {
  name   = var.rds_sg_name
  vpc_id = module.vpc.vpc_id

  # HTTP access from VPC
  ingress {
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = var.tcp_proctocol
    security_groups = [aws_security_group.ecs_sg.id] # Allow traffic only from ECS instances
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = var.rds_sg_name
  })
}