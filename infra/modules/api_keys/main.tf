provider "aws" {
  region = var.aws_region
}

# Generate a random hex string for each API key name
resource "random_id" "api_keys" {
  for_each   = toset(var.api_key_names)
  byte_length = 16  # 16 bytes gives you a 32-character hex string
}

# Create a Secrets Manager secret for each API key
resource "aws_secretsmanager_secret" "api_keys" {
  for_each = toset(var.api_key_names)
  name     = "${var.environment}/control-plane/${each.value}"
  description = var.api_key_descriptions[index(var.api_key_names, each.value)]
}

# Create a secret version to store the actual API key value as JSON
resource "aws_secretsmanager_secret_version" "api_keys" {
  for_each      = toset(var.api_key_names)
  secret_id     = aws_secretsmanager_secret.api_keys[each.value].id
  secret_string = jsonencode({
    api_key = random_id.api_keys[each.value].hex
  })
}
