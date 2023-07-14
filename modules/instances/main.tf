# =========
# Instances
# =========

# Image for instances
data "aws_ami" "ami-challenge" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Security-Challenge"]
  }
  filter {
    name   = "owner-id"
    values = ["269304746140"]
  }
}


# instance1
resource "aws_instance" "challenge-instance1" {
  ami                         = data.aws_ami.ami-challenge.id
  instance_type               = "t2.micro"
  subnet_id                   = var.private_subnet1
  vpc_security_group_ids      = [var.sg_instance1]
  associate_public_ip_address = false
  source_dest_check           = false
  key_name                    = var.keypair

  # root disk
  root_block_device {
    #   device_name = "/dev/xvda"
    volume_size = "15"
    volume_type = "gp2"
    encrypted   = true
  }

  tags = {
    Name = "challenge-instance1"
  }
}

# instance2
resource "aws_instance" "challenge-instance2" {
  ami                         = data.aws_ami.ami-challenge.id
  instance_type               = "t2.micro"
  subnet_id                   = var.private_subnet2
  vpc_security_group_ids      = [var.sg_instance2]
  associate_public_ip_address = false
  source_dest_check           = false
  key_name                    = var.keypair

  # root disk
  root_block_device {
    #   device_name = "/dev/xvda"
    volume_size = "15"
    volume_type = "gp2"
    encrypted   = true
  }

  tags = {
    Name = "challenge-instance2"
  }
}
