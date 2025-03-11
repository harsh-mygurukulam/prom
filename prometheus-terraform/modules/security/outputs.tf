output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

output "alb_sg_id" {  # ✅ Add this to expose ALB SG
  value = aws_security_group.alb_sg.id
}

