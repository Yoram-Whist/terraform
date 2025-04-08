module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name            = var.vpc_name
  cidr            = var.vpc_cidr_block
  azs             = var.availability_zones
  private_subnets = var.public_subnet_cidrs
  public_subnets  = var.private_subnet_cidrs

  enable_vpn_gateway     = var.enable_vpn_gateway
  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway     # Two NAT gateways, one per private subnet
  one_nat_gateway_per_az = var.one_nat_gateway_per_az # Ensure that the NAT are in different AZs

  tags = local.common_tags
}
