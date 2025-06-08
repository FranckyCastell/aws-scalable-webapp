module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project}-vpc-${var.environment}"

  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets_cidr
  private_subnets = var.private_subnets_cidr

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  tags = var.tags
}