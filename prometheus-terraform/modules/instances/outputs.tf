output "vpc_id" {
  value = var.vpc_id 
}





output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}

output "public_subnet_ids" {
  value = var.public_subnet_ids  # ✅ Correct: Use networking module's output
}
output "private_subnet_ids" {
  value = var.private_subnet_ids  # ✅ Use variable instead of undeclared resource
}
