# ==================================
# build security group for instance
# ==================================

# Security Group for instance1
resource "aws_security_group" "luis-sg-instance1" {
  name        = "luis-sg-instance1"
  description = "Security Group for instance1"
  vpc_id      = var.vpc_id
  tags = {
    Name = "luis-sg-instance1"
  }
}

