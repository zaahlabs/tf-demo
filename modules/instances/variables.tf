# keypair
variable "keypair" {
  type        = string
  description = "keypair for instances"
}

# private subnet1
variable "private_subnet1" {
  type        = string
  description = "private subnet 1"
}

# security group for instance1
variable "sg_instance1" {
  type        = string
  description = "security group for vpc endpoint az1"
}