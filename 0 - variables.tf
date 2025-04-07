variable "aws_region" {
  type        = string
  description = "Region to use for AWS resources"
  default     = "us-west-1"
}

variable "vpc_name" {
  type        = string
  description = "The name of the vpc"
  default     = "TF-Yoram"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to use in the specified region"
  default     = ["us-west-1a", "us-west-1b"]
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "nat_gateway_eip" {
  description = "Enable NAT Gateway Elastic IPs"
  type        = bool
  default     = true
}