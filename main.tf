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
  cidr_blocks     = var.cidr_blocks
  private_subnet1 = module.vpc.private_subnet1
  private_subnet2 = module.vpc.private_subnet2
}

# Instances module
module "instances" {
  source          = "./modules/instances"
  keypair         = var.keypair
  private_subnet1 = module.vpc.private_subnet1
  private_subnet2 = module.vpc.private_subnet2
  sg_instance1    = module.security.sg_instance1
  sg_instance2    = module.security.sg_instance2
}

# ALB module
module "alb" {
  source         = "./modules/alb"
  vpc_id         = module.vpc.vpc_id
  instance1_id   = module.instances.instance1_id
  instance2_id   = module.instances.instance2_id
  sg_alb         = module.security.sg_alb
  public_subnet1 = module.vpc.public_subnet1
  public_subnet2 = module.vpc.public_subnet2
}

# Cloudfront module
#module "cloudfront" {
#  source  = "./modules/cloudfront"
#  alb_dns = module.alb.alb_dns
#}

# WAF module
#module "waf" {
#  source                  = "./modules/waf"
#  cloudfront_distribution = module.cloudfront.cloudfront_distribution
#}

# Flowlogs module
module "flowlogs" {
  source = "./modules/flowlogs"
  vpc_id = module.vpc.vpc_id
}
