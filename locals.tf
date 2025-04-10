data "aws_secretsmanager_secret_version" "creds" {
  secret_id = var.rds_creds_secrets
}

locals {
  common_tags = {
    creator     = var.creator
    Environment = "${terraform.workspace}"
  }

  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}