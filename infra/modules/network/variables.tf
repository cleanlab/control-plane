variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "number_of_subnets" {
  description = "Number of subnets to create"
  type        = number
}

variable "environment" {
  description = "Environment"
  type        = string
}
