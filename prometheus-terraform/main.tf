provider "aws" {
  region = "eu-north-1"
}

module "networking" {
  source = "./modules/networking"
  vpc_cidr = "192.168.0.0/16"
  public_subnets  = ["192.168.10.0/24", "192.168.20.0/24"]
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
  public_subnet_ids = module.networking.public_subnet_ids  
  public_sg_id = module.security.public_sg_id
}





