output "vpc_id" {
  value = var.vpc_id 
}

output "alb_sg_id" {
  value = var.alb_sg_id  # ✅ Use variable instead of undeclared resource
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value = var.alb_dns_name  # ✅ Use variable instead of undeclared resource
}

output "public_subnet_ids" {
  value = var.public_subnet_ids  # ✅ Correct: Use networking module's output
}
output "private_subnet_ids" {
  value = var.private_subnet_ids  # ✅ Use variable instead of undeclared resource
}
output "tool_tg_arn" {
  description = "ARN of the Tool Target Group"
  value       = aws_lb_target_group.tool_tg.arn
}
