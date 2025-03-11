output "vpc_id" {
  value = module.networking.vpc_id
}
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.networking.alb_dns_name
}
output "public_subnet_ids" {
  value = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.networking.private_subnet_ids
}
