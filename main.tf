# Provider
provider "aws" {
  region = "us-east-1"
}

# VPC module
module "vpc" {
  source      = "./modules/vpc"
  cidr_blocks = var.cidr_blocks
}

# Security module
module "security" {
  source          = "./modules/security"
  vpc_id          = module.vpc.vpc_id
}

# Instances module
module "instance" {
  source          = "./modules/instances"
  keypair         = var.keypair
  private_subnet1 = module.vpc.private_subnet1
  sg_instance1    = module.security.sg_instance1
}