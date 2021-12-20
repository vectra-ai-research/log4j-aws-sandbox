
resource "aws_vpc" "kat-JNDI-exploit-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "Name" = "kat-JNDI-Exploit-VPC"
  }
}

resource "aws_subnet" "kat-Public-Subnet-1" {
  vpc_id                  = aws_vpc.kat-JNDI-exploit-vpc.id
  cidr_block              = var.public_subnet_1_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-west-2a"

  tags = {
    "Name" = "Public-Subnet-1"
  }
}


resource "aws_route_table" "kat-Public-Route-Table" {
  vpc_id = aws_vpc.kat-JNDI-exploit-vpc.id

  tags = {
    "Name" = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "Public_Subnet_1_Association" {
  route_table_id = aws_route_table.kat-Public-Route-Table.id
  subnet_id      = aws_subnet.kat-Public-Subnet-1.id
}


resource "aws_internet_gateway" "kat-vpc_igw" {
  vpc_id = aws_vpc.kat-JNDI-exploit-vpc.id
  tags = {
    "Name" = "VPC-IGW"
  }
}

resource "aws_route" "kat-vpc_igw_route" {
  route_table_id         = aws_route_table.kat-Public-Route-Table.id
  gateway_id             = aws_internet_gateway.kat-vpc_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "kat-ec2-key"
  public_key = var.public_key

}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "ec2-connect-sg" {
  name   = "EC2-SG"
  vpc_id = aws_vpc.kat-JNDI-exploit-vpc.id

  ingress = [
  {
    cidr_blocks      = ["18.237.140.160/29"]
    description      = "SSH from EC2 Instance Connect from the Browser"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    tags = {
      Name = "Allow EC2 Instance Connect"
      }
  },{
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
    description      = "Allow inboud SSH from IP of host which deployed the infra"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
    tags = {
      Name = "Allow inbound to vulnerabl app from Corp IP"
    }
    }
  ]

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "Egress"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = -1
    self             = false
    security_groups  = []
    to_port          = 0
  }]

}

resource "aws_iam_instance_profile" "kat-JNDI-EC2-Profile" {
  name = "kat-JNDI-EC2-Profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "kat-JNDI-EC2-Role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_instance" "kat-JNDI-sandbox" {
  ami             = data.aws_ami.amazon-linux.id
  iam_instance_profile = "kat-JNDI-EC2-Profile"
  associate_public_ip_address = true
  key_name        = aws_key_pair.ssh_key.key_name
  instance_type   = var.ec2_instance_type
  subnet_id       = aws_subnet.kat-Public-Subnet-1.id
  security_groups = [aws_security_group.ec2-connect-sg.id]
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum install java-1.8.0-openjdk -y",
      "wget http://web.archive.org/web/20211210224333/https://github.com/feihong-cs/JNDIExploit/releases/download/v1.2/JNDIExploit.v1.2.zip",
      "unzip JNDIExploit.v1.2.zip",
      "MY_IP=$(hostname -I | awk '{print $1}')",
      "java -jar JNDIExploit-1.2-SNAPSHOT.jar -i $MY_IP -p 8888",
      "sudo docker exec vulnerable-app apk add curl",
      "exit 0",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    agent       = true
  }  

  user_data       = <<-EOF
              #!/bin/bash
              sudo yum install docker -y
              sudo systemctl start docker.service
              sudo docker run --name vulnerable-app -p 8080:8080 ghcr.io/christophetd/log4shell-vulnerable-app
              EOF
  tags = {
    Name = "kat-JNDI-sandbox"
  }
}

output "kat-JNDI-sandbox" {
  value = aws_instance.kat-JNDI-sandbox.public_ip
}
