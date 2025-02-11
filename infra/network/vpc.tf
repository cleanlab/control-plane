# Control Plane VPC

resource "aws_vpc" "control_plane_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "control_plane_subnet_1a" {
  vpc_id = aws_vpc.control_plane_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "control_plane_subnet_1b" {
  vpc_id = aws_vpc.control_plane_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2b"
}

resource "aws_internet_gateway" "control_plane_internet_gateway" {
  vpc_id = aws_vpc.control_plane_vpc.id
}
