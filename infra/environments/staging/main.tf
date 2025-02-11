provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source         = "../../modules/network"
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  public_subnets = var.public_subnets
  azs            = var.azs
}
