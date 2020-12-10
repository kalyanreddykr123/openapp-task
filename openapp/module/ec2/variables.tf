variable "vpc_id" {}
variable "ami_baseos" {}
variable "instance_type" {}
variable "sgs" { type="list" }
variable "size" { default = "20" }
variable "voltype" { default = "gp2"}
variable "ebs_optimized" { default=false }
variable "user_data" {}
variable "iam_instance_profile" {}
variable "subnet_id" {}