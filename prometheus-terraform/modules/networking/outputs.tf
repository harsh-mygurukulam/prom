output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "alb_sg_id" {  # ✅ Add this
  value = aws_security_group.alb_sg.id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.app_lb.dns_name
}

