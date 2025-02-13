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
  aws_region     = var.aws_region
}

module "domains" {
  source = "../../modules/domains"
  environment = "staging"
  domain = var.domain
  posthog_reverse_proxy_subdomain = var.posthog_reverse_proxy_subdomain
  metronome_reverse_proxy_subdomain = var.metronome_reverse_proxy_subdomain
}

module "api_keys" {
  source = "../../modules/api_keys"
  environment = "staging"
  aws_region = var.aws_region
  api_key_name = var.api_key_name
  api_key_description = var.api_key_description
  api_key_field_names = var.api_key_field_names
}
