variable "vpc_cidr" {}
variable "public_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "alb_sg_id" {  # ✅ Fix missing security group variable
  description = "ALB Security Group ID"
  type        = string
}
variable "tool_tg_arn" {
  description = "Target Group ARN for the tool"
  type        = string
}
