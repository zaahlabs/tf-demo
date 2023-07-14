# ===================
# Main variables file
# ===================

variable "cidr_blocks" {
  type        = list(string)
  description = "cidr blocks"
}

variable "keypair" {
  type        = string
  description = "keypair for instances"
  default     = ""
}
