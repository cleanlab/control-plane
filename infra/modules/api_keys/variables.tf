variable "environment" {
  description = "Environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "api_key_names" {
  description = "API key names"
  type        = list(string)
}

variable "api_key_descriptions" {
  description = "API key descriptions"
  type        = list(string)
}
