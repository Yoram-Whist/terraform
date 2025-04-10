module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.11.0"

  engine                = var.rds_engine
  engine_version        = "${var.rds_engine_version}${var.rds_engine_sub_version}"
  instance_class        = var.rds_instance
  allocated_storage     = var.rds_storage_size
  max_allocated_storage = var.rds_storage_size
  storage_type          = var.storage_type

  identifier = local.db_creds.database

  db_name                     = var.rds_db_name
  port                        = var.mysql_port
  manage_master_user_password = var.manage_master_user_password
  username                    = local.db_creds.username
  password                    = local.db_creds.password

  multi_az               = var.rds_multi_az
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  create_db_subnet_group = var.create_db_subnet_group
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  family = "${var.rds_engine}${var.rds_engine_version}"

  # DB option group
  major_engine_version = var.rds_engine_version

  # Database Deletion Protection - for production enable both
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = local.common_tags
}