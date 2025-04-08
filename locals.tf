data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "rds-cred-tf"
}

locals {
  common_tags = {
    creator     = "Yoram"
    Environment = "production"
  }

  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}