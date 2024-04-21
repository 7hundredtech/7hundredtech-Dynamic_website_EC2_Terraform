# Create Custom VPC
module "vpc" {
  source                      = "./modules/vpc"
  project_name                = var.project_name
  vpc_cidr                    = var.vpc_cidr
  public_subnet_az1_cidr      = var.public_subnet_az1_cidr
  public_subnet_az2_cidr      = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
}
# Create Nat_Gateway
module "nat_gateway" {
  source                    = "./modules/nat_gateway"
  vpc_id                    = module.vpc.vpc_id
  public_subnet_az1_id      = module.vpc.public_subnet_az1_id
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
}
# Create Security Groups
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}
# Create Application Load Balancer
module "alb" {
  source               = "./modules/alb"
  project_name         = var.project_name
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  alb_sg_id            = module.security_groups.alb_sg_id
  vpc_id               = module.vpc.vpc_id
  #acm_certificate_arn  = module.acm.acm_certificate_arn
}

# Create Autoscalling Group
module "asg" {
  source                    = "./modules/asg"
  key_name                  = var.key_name
  project_name              = var.project_name
  instance_type             = var.instance_type
  alb_tg_arn                = module.alb.alb_tg_arn
  private_app_subnet_az1_id = module.vpc.private_app_subnet_az1_id
  private_app_subnet_az2_id = module.vpc.private_app_subnet_az2_id
  website_sg_id             = module.security_groups.website_sg_id
  alb_sg_id                 = module.security_groups.alb_sg_id
}

#Create Route 53
module "route53" {
  source           = "./modules/route53"
  endpoint         = var.endpoint
  alb_dns_endpoint = module.alb.alb_dns_endpoint
  alb_zone_id      = module.alb.alb_zone_id
  domain_name      = var.domain_name
}



