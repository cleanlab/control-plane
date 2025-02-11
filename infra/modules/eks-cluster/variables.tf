variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "min_size" {
  description = "Minimum size"
  type        = number
}

variable "max_size" {
  description = "Maximum size"
  type        = number
}

variable "desired_size" {
  description = "Desired size"
  type        = number
}

variable "instance_types" {
  description = "Instance types"
  type        = list(string)
}

variable "environment" {
  description = "Environment"
  type        = string
}
