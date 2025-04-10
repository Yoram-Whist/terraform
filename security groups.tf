# RDS mysql security group 
resource "aws_security_group" "rds_sg" {
  name   = var.rds_sg_name
  vpc_id = module.vpc.vpc_id

  # HTTP access from VPC
  ingress {
    from_port       = var.mysql_port
    to_port         = var.mysql_port
    protocol        = var.tcp_protocol
    security_groups = [module.ecs_service.security_group_id] # Allows traffic only from ECS instances
  }

  tags = merge(local.common_tags, {
    Name = var.rds_sg_name
  })
}