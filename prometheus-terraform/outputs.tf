output "vpc_id" {
  value = module.networking.vpc_id
}

output "public_instance_ip" {
  value = module.instances.public_instance_ip
}
