# vpc id
variable "vpc_id" {
  type        = string
  description = " vpc id"
}

# cidr blocks
variable "cidr_blocks" {
  type        = list(string)
  description = "cidr blocks definition"
}

variable "private_subnet1" {
  type        = string
  description = "private subnet 1"
}

# private subnet 2
variable "private_subnet2" {
  type        = string
  description = "private subnet 2"
}







