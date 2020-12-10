provider "aws" {
  region = "us-east-1"
}

locals {
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl status apache2
sudo netstat -tulpa | grep :80
EOF
}

module "vpc" {
  source = "../module/vpc"
  vpc_cidr = "10.0.0.0/16"
}

module "sg" {
  source = "../module/sg" 
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "../module/iam"
}

module "elb" {
  depends_on = [module.ec2]
  source = "../module/elb"
  name = "elb"
  subnets = ["${element(split(",",module.vpc.public_subnets), 0)}"]
  internal = "false"
  security_groups = [module.sg.albsg_id,module.sg.sg_id]
   listener = [
    {
      instance_port     = "80"
      instance_protocol = "http"
      lb_port           = "80"
      lb_protocol       = "http"
    }
   ]
    health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
  number_of_instances = 1
  instances           = [module.ec2.id]
}

module "ec2" {
  depends_on = [module.vpc]
  source = "../module/ec2"
  vpc_id = module.vpc.vpc_id
  ami_baseos = "ami-00ddb0e5626798373"
  instance_type = "t3.micro"
  sgs = [module.sg.sg_id]
  iam_instance_profile = module.iam.name
  subnet_id = "${element(split(",",module.vpc.private_subnets), 0)}"
  user_data = local.user_data
}
