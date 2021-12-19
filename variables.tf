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

variable "public_key" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDrEvI51McoC0w6nu+kbGzm8bG6LNIkFiPH5X4ITtTuki6sOe5uren7/zibzK+oHUJkJY4gTJ8m3dfXZCfGQHekz9TuT+/n9f89JJVA1Hp39gEmPWLkdl9pJtGkPooHtk1cmpooZIFYyb264HW9XTeIqpI/jYlzVTC3VTLXLFOnxajDXcIZVAt8lZJMnxDKWc+asJRFlnn4nYRZXnGSg4sdcUeWjT+atR77bb3QGUjNzUqv+bReGQI7OA8s89qHHKieLX7hHD+LpjR+lMhghCS8lsz7zGilEiPpFMtVQcZqNtZAc5UYSuglqDCZJW8tEaZH265LGwWA6QE/wZL5of1JDNChloYDq+7idcIR2DLGSG/M1rsRK1DNmraOrFaHP2rQZ5mkNeO52kcFSvVmYksECJ2lPVVXizkOGIYtIH2ipX32nMpCGuQQT7FM10AlpW/RaVLoAQkHmgDHZOIFemnLyPb6EqpZkiVgEyFdt6Wm+tKMrudhCayCs9/oU+Fb+RE= kat-my-key"
}

variable "deployment_prefix"{
  default = "kat-"
}