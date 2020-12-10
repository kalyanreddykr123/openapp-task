
resource "aws_key_pair" "key" {
    key_name = "key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDVUVBf8Lgscm2Ny8brA1r70zoSJKJA3wFBvQ8xZ8Gsdw9btExMkpsEUYpS5q4nXmXw9CH7jQF296ay65gV9TuKpZIgF7TZ1pe2By2Af8JSFaYax/Pap8eO8B6s9rQ3TC3CKPrVIwagrOJvICtl6ZFC9nkOB2km1UhUW7qRpp1rnKcwe6BwZ1LiYI53gTYvdv+ScHBcRZQm8Trt1I1PQcjTAPgQf4nYPShYmclrGUHpAca4OY7kwNquS1w0MeKOvmamb21zXaDtgTYR84paJ58Gw+iGpD6kUkWFXG2cKUlIZTJ0WfmC7ovrNcRO3reHpOhKcWBtJfC6ihvX7PR4P8qL samiteon@master"
}

output "key_id" {
       value = "${aws_key_pair.key.id}"
}

# variable "keyname" {}
# variable "publickey" {}