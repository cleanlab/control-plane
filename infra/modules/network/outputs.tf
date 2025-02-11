output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.this.id
}

output "subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public[*].id
}
