# Get Private Subnets

data "aws_subnet" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "private_subnet"
  }
}

module "key" {
  source = "./keypair"
}

#EC2 instance template
resource "aws_instance" "instance" {
    ami                    = "${var.ami_baseos}"
    instance_type          = "${var.instance_type}"
    key_name               = module.key.key_id
    vpc_security_group_ids = "${var.sgs}"
    subnet_id              = var.subnet_id
    ebs_optimized          = "${var.ebs_optimized}"
    user_data              = base64encode(var.user_data)
    iam_instance_profile   = var.iam_instance_profile
    root_block_device      {
                                volume_size = "${var.size}"
                                volume_type = "${var.voltype}"
                             }
     tags = {
        Name = "apache-ec2",
    }

}
