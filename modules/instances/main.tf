# =============
# EC2 Instance
# =============

# instance1
resource "aws_instance" "luis-instance1" {
  ami                         = "ami-04823729c75214919"
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
    Name = "luis-instance1"
  }
}