# module "db" {
#   source = "terraform-aws-modules/rds/aws"

#   engine            = "mysql"
#   engine_version    = "8.0.40"
#   instance_class    = "db.t3.micro"
#   allocated_storage = 20
#   storage_type      = "gp3"

#   db_name  = "terraform-database"
#   username = "admin"
#   port     = "3306"

#   vpc_id                    = module.vpc.vpc_id
#   vpc_security_group_ids    = [aws_security_group.rds_sg.id]
#   create_db_subnet_group    = true
#   subnet_ids                = module.vpc.private_subnets

#   tags = local.common_tags
# }