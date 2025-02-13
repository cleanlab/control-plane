provider "aws" {
  region = var.aws_region
}

# Generate a random hex string for each API key name
resource "random_id" "api_keys" {
  for_each   = toset(var.api_key_field_names)
  byte_length = 32
}

# Create a Secrets Manager secret for each API key
resource "aws_secretsmanager_secret" "api_keys" {
  name     = "${var.environment}/control-plane/${var.api_key_name}"
  description = var.api_key_description

  replica {
    region = var.api_key_replica_region
  }
}

# Create a secret version to store the actual API key value as JSON
resource "aws_secretsmanager_secret_version" "api_keys" {
  secret_id     = aws_secretsmanager_secret.api_keys.id
  secret_string = jsonencode({
    for name in var.api_key_field_names : name => random_id.api_keys[name].hex
  })
}
