output "vpc_id" {
  value = module.networking.vpc_id  # ✅ Correct reference
}

output "public_subnet_ids" {
  value = module.networking.public_subnet_ids  # ✅ Correct reference
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids  # ✅ Correct reference
}

output "alb_sg_id" {
  value = module.security.alb_sg_id  # ✅ Correct reference
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.networking.alb_dns_name  # ✅ Correct reference
}
