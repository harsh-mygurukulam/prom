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

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}
variable "alb_sg_id" {
  description = "ALB Security Group ID"
  type        = string
}
