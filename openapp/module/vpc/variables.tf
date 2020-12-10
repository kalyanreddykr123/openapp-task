variable "single_nat_gw" {
  type    = string
  default = "false"
}

variable "az_list" {
  type = list
  default = ["us-east-1a"]
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}