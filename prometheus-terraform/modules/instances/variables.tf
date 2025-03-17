variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}

variable "public_subnet_ids" {  # ✅ Change `public_subnet_id` → `public_subnet_ids` (list of subnets)
  type = list(string)
}

variable "public_sg_id" {}  # ✅ Keep public security group, remove private one
