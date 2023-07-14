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
resource "aws_vpc" "challenge-vpc" {
  cidr_block           = var.cidr_blocks[0]
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "challenge-vpc"
  }
}

# Private subnet1
resource "aws_subnet" "challenge-private1" {
  cidr_block        = var.cidr_blocks[1]
  vpc_id            = aws_vpc.challenge-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[0]
  tags = {
    Name = "challenge-private1"
  }
}

# Private subnet2
resource "aws_subnet" "challenge-private2" {
  cidr_block        = var.cidr_blocks[2]
  vpc_id            = aws_vpc.challenge-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[1]
  tags = {
    Name = "challenge-private2"
  }
}

# Public subnet1
resource "aws_subnet" "challenge-public1" {
  cidr_block        = var.cidr_blocks[3]
  vpc_id            = aws_vpc.challenge-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[0]
  tags = {
    Name = "challenge-public1"
  }
}

# Public subnet2
resource "aws_subnet" "challenge-public2" {
  cidr_block        = var.cidr_blocks[4]
  vpc_id            = aws_vpc.challenge-vpc.id
  availability_zone = data.aws_availability_zones.nolocal.names[1]
  tags = {
    Name = "challenge-public2"
  }
}

# ==========
# Gateways
# ==========

# Internet gateway
resource "aws_internet_gateway" "challenge-igw" {
  vpc_id = aws_vpc.challenge-vpc.id

  tags = {
    Name = "challenge-igw"
  }
}

# Elastic IPs for nat gateway
resource "aws_eip" "nat_eip" {
  count      = 2
  domain        = "vpc"
  depends_on = [aws_internet_gateway.challenge-igw]
}

# Nat gateway1
resource "aws_nat_gateway" "challenge-natgw1" {
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.challenge-private1.id
  tags = {
    Name = "challenge-natgw1"
  }
}

# Nat gateway2
resource "aws_nat_gateway" "challenge-natgw2" {
  allocation_id = aws_eip.nat_eip[1].id
  subnet_id     = aws_subnet.challenge-private2.id
  tags = {
    Name = "challenge-natgw2"
  }
}


# =============
# Route tables
# =============

# Public route table 
resource "aws_route_table" "challenge-rt-public" {
  vpc_id = aws_vpc.challenge-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.challenge-igw.id
  }
  tags = {
    Name = "challenge-rt-public"
  }
}

# association for public subnet1
resource "aws_route_table_association" "challenge-assoc-rt-public1" {
  subnet_id      = aws_subnet.challenge-public1.id
  route_table_id = aws_route_table.challenge-rt-public.id
}

# association for public subnet1
resource "aws_route_table_association" "challenge-assoc-rt-public2" {
  subnet_id      = aws_subnet.challenge-public2.id
  route_table_id = aws_route_table.challenge-rt-public.id
}

# Private route table1
resource "aws_route_table" "challenge-rt-private1" {
  vpc_id = aws_vpc.challenge-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.challenge-natgw1.id
  }
  tags = {
    Name = "challenge-rt-private1"
  }
}

# Private route table2
resource "aws_route_table" "challenge-rt-private2" {
  vpc_id = aws_vpc.challenge-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.challenge-natgw2.id
  }
  tags = {
    Name = "challenge-rt-private2"
  }
}

# association for private subnet1
resource "aws_route_table_association" "challenge-assoc-rt-private1" {
  subnet_id      = aws_subnet.challenge-private1.id
  route_table_id = aws_route_table.challenge-rt-private1.id
}

# association for private subnet2
resource "aws_route_table_association" "challenge-assoc-rt-private2" {
  subnet_id      = aws_subnet.challenge-private2.id
  route_table_id = aws_route_table.challenge-rt-private2.id
}

