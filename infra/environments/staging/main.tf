provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source         = "../../modules/network"
  vpc_cidr       = var.vpc_cidr
  number_of_subnets = var.number_of_subnets
  environment     = "staging"
}

module "eks_cluster" {
  source         = "../../modules/eks-cluster"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets
  min_size       = var.cluster_min_size
  max_size       = var.cluster_max_size
  desired_size   = var.cluster_desired_size
  instance_types = var.cluster_instance_types
  environment    = "staging"
}
