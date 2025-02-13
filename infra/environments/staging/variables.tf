variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "number_of_subnets" {
  description = "Number of subnets to create"
  type        = number
  default     = 3
}

variable "cluster_min_size" {
  description = "Minimum number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "cluster_max_size" {
  description = "Maximum number of nodes in the cluster"
  type        = number
  default     = 5
}

variable "cluster_desired_size" {
  description = "Desired number of nodes in the cluster"
  type        = number
  default     = 2
}

variable "cluster_instance_types" {
  description = "Instance types for the cluster"
  type        = list(string)
  default     = ["m5.large", "m5.xlarge"]
}

variable "domain" {
  description = "Domain"
  type        = string
  default     = "cleanlab.ai"
}

variable "posthog_reverse_proxy_subdomain" {
  description = "PostHog Reverse Proxy Subdomain"
  type        = string
  default     = "ph-staging-2isxg5ngi"
}

variable "metronome_reverse_proxy_subdomain" {
  description = "Metronome Reverse Proxy Subdomain"
  type        = string
  default     = "billing-staging-2isxg5ngi"
}

variable "api_key_name" {
  description = "API key name"
  type        = string
  default     = "billing/internal-api-keys"
}

variable "api_key_description" {
  description = "API key description"
  type        = string
  default     = "API key to authenticate internal billing API requests"
}

variable "api_key_field_names" {
  description = "API key field names"
  type        = list(string)
  default     = ["codex"]
}

variable "api_key_replica_region" {
  description = "API key replica region"
  type        = string
  default     = "us-east-1"
}
