variable "environment" {
  description = "Environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "api_key_name" {
  description = "API key name"
  type        = string
}

variable "api_key_description" {
  description = "API key description"
  type        = string
}

variable "api_key_field_names" {
  description = "API key field names"
  type        = list(string)
}
