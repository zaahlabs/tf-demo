# =======================================
# build security groups and vpc endpoints
# =======================================

# Security Group for instance1
resource "aws_security_group" "challenge-sg-instance1" {
  name        = "challenge-sg-instance1"
  description = "Security Group for instance1"
  vpc_id      = var.vpc_id
  tags = {
    Name = "challenge-sg-instance1"
  }
}

# instance1 security group inbound rule
resource "aws_security_group_rule" "allow-http-instance1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-instance1.id
}

# instance1 security group outbound rule
resource "aws_security_group_rule" "outbound-instance1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-instance1.id
}

# Security Group for instance2
resource "aws_security_group" "challenge-sg-instance2" {
  name        = "challenge-sg-instance2"
  description = "Security Group for instance2"
  vpc_id      = var.vpc_id
  tags = {
    Name = "challenge-sg-instance2"
  }
}

# instance2 security group inbound rule
resource "aws_security_group_rule" "allow-http-instance2" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-instance2.id
}

# instance2 security group outbound rule
resource "aws_security_group_rule" "outbound-instance2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-instance2.id
}

# Security Group for ALB
resource "aws_security_group" "challenge-sg-alb" {
  name        = "challenge-sg-alb"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id
  tags = {
    Name = "challenge-sg-alb"
  }
}

# alb security group inbound rule
resource "aws_security_group_rule" "allow-http-alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-alb.id
}

# alb security group outbound rule
resource "aws_security_group_rule" "outbound-alb" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-alb.id
}

# Security Group for vpc endpoint az1
resource "aws_security_group" "challenge-sg-vpce-az1" {
  name        = "challenge-sg-vpce-az1"
  description = "Security Group for vpc endpoint az1"
  vpc_id      = var.vpc_id
  tags = {
    Name = "challenge-sg-vpce-az1"
  }
}

# vpc endpoint az1 inbound rule
resource "aws_security_group_rule" "allow-https-az1" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_blocks[0]]
  security_group_id = aws_security_group.challenge-sg-vpce-az1.id
}

# vpc endpoint az1 outbound rule
resource "aws_security_group_rule" "outbound-vpce1" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-vpce-az1.id
}

# Security Group for vpc endpoint az2
resource "aws_security_group" "challenge-sg-vpce-az2" {
  name        = "challenge-sg-vpce-az2"
  description = "Security Group for vpc endpoint az2"
  vpc_id      = var.vpc_id
  tags = {
    Name = "challenge-sg-vpce-az2"
  }
}

# vpc endpoint az2 inbound rule
resource "aws_security_group_rule" "allow-https-az2" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.cidr_blocks[0]]
  security_group_id = aws_security_group.challenge-sg-vpce-az2.id
}

# vpc endpoint az2 outbound rule
resource "aws_security_group_rule" "outbound-vpce2" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.challenge-sg-vpce-az2.id
}

# ==============
# VPC Endpoints
# ==============

# S3 Gateway endpoint
resource "aws_vpc_endpoint" "s3-endpoint" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.us-east-1.s3"
  tags = {
    Name = "challenge-s3-endpoint"
  }
}

# ssm vpce
resource "aws_vpc_endpoint" "ec2-ssm" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-east-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [
    var.private_subnet1,
    var.private_subnet2
  ]
  security_group_ids = [
    aws_security_group.challenge-sg-vpce-az2.id,
    aws_security_group.challenge-sg-vpce-az2.id
  ]
}

# ec2messages vpce
resource "aws_vpc_endpoint" "ec2-ec2messages" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-east-1.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.private_subnet1,
    var.private_subnet2
  ]
  security_group_ids = [
    aws_security_group.challenge-sg-vpce-az2.id,
    aws_security_group.challenge-sg-vpce-az2.id
  ]
}

# ssmmessages vpce
resource "aws_vpc_endpoint" "ec2-ssmmessages" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.us-east-1.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    var.private_subnet1,
    var.private_subnet2
  ]
  security_group_ids = [
    aws_security_group.challenge-sg-vpce-az2.id,
    aws_security_group.challenge-sg-vpce-az2.id
  ]
}


