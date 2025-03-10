variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "public_sg_id" {}
variable "private_sg_id" {}
variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

