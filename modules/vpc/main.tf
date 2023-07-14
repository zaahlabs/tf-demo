# ======================================
# VPC Module
# Deploys VPC, subnets and route tables
# ======================================

# Get availability zones (no local zones)
data "aws_availability_zones" "nolocal" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# VPC
resource "aws_vpc" "luis-vpc" {
  cidr_block           = var.cidr_blocks[0]
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "luis-vpc"
  }
}

# Private subnet1
resource "aws_subnet" "luis-private1" {
  cidr_block        = var.cidr_blocks[1]
  vpc_id            = aws_vpc.luis-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[0]
  tags = {
    Name = "luis-private1"
  }
}

# Private subnet2
resource "aws_subnet" "luis-private2" {
  cidr_block        = var.cidr_blocks[2]
  vpc_id            = aws_vpc.luis-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[1]
  tags = {
    Name = "luis-private2"
  }
}

# Public subnet1
resource "aws_subnet" "luis-public1" {
  cidr_block        = var.cidr_blocks[3]
  vpc_id            = aws_vpc.luis-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[0]
  tags = {
    Name = "luis-public1"
  }
}

# Public subnet2
resource "aws_subnet" "luis-public2" {
  cidr_block        = var.cidr_blocks[4]
  vpc_id            = aws_vpc.luis-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[1]
  tags = {
    Name = "luis-public2"
  }
}

# ==========
# Gateways
# ==========

# Internet gateway
resource "aws_internet_gateway" "luis-igw" {
  vpc_id = aws_vpc.luis-vpc.id

  tags = {
    Name = "luis-igw"
  }
}

# =============
# Route tables
# =============

# Public route table 
resource "aws_route_table" "luis-rt-public" {
  vpc_id = aws_vpc.luis-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.luis-igw.id
  }
  tags = {
    Name = "luis-rt-public"
  }
}

# association for public subnet1
resource "aws_route_table_association" "luis-assoc-rt-public1" {
  subnet_id      = aws_subnet.luis-public1.id
  route_table_id = aws_route_table.luis-rt-public.id
}

# association for public subnet2
resource "aws_route_table_association" "luis-assoc-rt-public2" {
  subnet_id      = aws_subnet.luis-public2.id
  route_table_id = aws_route_table.luis-rt-public.id
}

# Private route table1
resource "aws_route_table" "luis-rt-private1" {
  vpc_id = aws_vpc.luis-vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.luis-natgw1.id
#  }
  tags = {
    Name = "luis-rt-private1"
  }
}

# Private route table2
resource "aws_route_table" "luis-rt-private2" {
  vpc_id = aws_vpc.luis-vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.luis-natgw2.id
#  }
  tags = {
    Name = "luis-rt-private2"
  }
}

# association for private subnet1
resource "aws_route_table_association" "luis-assoc-rt-private1" {
  subnet_id      = aws_subnet.luis-private1.id
  route_table_id = aws_route_table.luis-rt-private1.id
}

# association for private subnet2
resource "aws_route_table_association" "luis-assoc-rt-private2" {
  subnet_id      = aws_subnet.luis-private2.id
  route_table_id = aws_route_table.luis-rt-private2.id
}

