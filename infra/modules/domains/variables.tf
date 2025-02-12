variable "environment" {
  description = "Environment"
  type        = string
}

variable "domain" {
  type = string
}

variable "posthog_reverse_proxy_subdomain" {
  type = string
}

variable "metronome_reverse_proxy_subdomain" {
  type = string
}