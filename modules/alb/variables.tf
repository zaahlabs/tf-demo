# VPC id
variable "vpc_id" {
  type        = string
  description = "challenge vpc id"
}

# Instance1 Id
variable "instance1_id" {
  type        = string
  description = "instance1 id"
}

# Instance2 Id
variable "instance2_id" {
  type        = string
  description = "instance2 id"
}
# ALB Security Group
variable "sg_alb" {
  type        = string
  description = "Security Group for ALB"
}

# Public subnet 1
variable "public_subnet1" {
  type        = string
  description = "Public subnet1"
}

# Public subnet 2
variable "public_subnet2" {
  type        = string
  description = "Public subnet2"
}
