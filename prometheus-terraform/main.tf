provider "aws" {
  region = "eu-north-1"
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = "192.168.0.0/16"
  public_subnets  = ["192.168.10.0/24", "192.168.20.0/24"]
  private_subnets = ["192.168.30.0/24", "192.168.40.0/24"]
  public_subnet_ids = module.networking.public_subnet_ids  
  alb_sg_id         = module.security.alb_sg_id           
  tool_tg_arn   = module.instances.tool_tg_arn 
}

module "security" {
  source = "./modules/security"
  vpc_id = module.networking.vpc_id
}

module "instances" {
  source = "./modules/instances"
  ami_id = "ami-02e2af61198e99faf"
  instance_type = "t3.micro"
  key_name = "ansible"
  public_subnet_id  = module.networking.public_subnet_ids[0]
  private_subnet_id = module.networking.private_subnet_ids[0]
  public_sg_id  = module.security.public_sg_id
  private_sg_id = module.security.private_sg_id
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids  # ✅ Add this line
  private_subnet_ids = module.networking.private_subnet_ids  # ✅ Pass as input
  alb_sg_id = module.security.alb_sg_id 
  alb_dns_name = module.networking.alb_dns_name
}

resource "aws_lb" "app_lb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.networking.alb_sg_id] # ✅ Correct reference
  
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}


output "public_instance_ip" {
  value = module.instances.public_instance_ip
}

output "private_instance_ip" {
  value = module.instances.private_instance_ip
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}
