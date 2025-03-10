output "vpc_id" {
  value = module.networking.vpc_id
}
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.networking.alb_dns_name
}
