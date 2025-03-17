variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "public_subnet_ids" {}  # ✅ Update to be a list
variable "public_sg_id" {}  # ✅ Only need public SG
