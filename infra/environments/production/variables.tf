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
