provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source         = "../../modules/network"
  vpc_cidr       = var.vpc_cidr
  number_of_subnets = var.number_of_subnets
  environment     = "production"
}
