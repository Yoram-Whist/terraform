terraform {
  required_version = "1.11.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "yoram-tf-backend"
    key    = "terraform.tfstate"
    region = "us-west-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}