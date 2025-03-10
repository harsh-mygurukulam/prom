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
