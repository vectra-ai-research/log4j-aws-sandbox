variable "region" {
  default = "us-west-2"

}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  default = "10.0.1.0/24"
}

variable "ec2_instance_type" {
  default = "t2.micro"
}