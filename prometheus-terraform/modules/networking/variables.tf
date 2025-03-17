#variable "vpc_cidr" {}
#variable "public_subnets" {
 # type = list(string)
#}
#variable "private_subnets" {
 # type = list(string)
#}


variable "vpc_cidr" {}

variable "public_subnets" {
  type = list(string)
  default = ["192.168.10.0/24", "192.168.20.0/24"]  # ✅ Sirf 2 public subnets
}
