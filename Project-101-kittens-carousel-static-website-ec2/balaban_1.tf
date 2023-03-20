terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "sec-grp" {
    name = "webserver-sec-grp"
    description = "Allow http and ssh ports."
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    tags = {
      Name = "ssh-http-sec-grp"
    } 
}


data "aws_ami" "ec2_ami" {
    owners = [ "amazon" ]
    most_recent = true
    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }  
}

resource "aws_instance" "webserver" {
    ami = data.aws_ami.ec2_ami.id
    instance_type = var.instance_type[0]
    key_name = var.instance_keypair
    vpc_security_group_ids = [ aws_security_group.sec-grp.id ]
    tags = {
      Name = "derya-webserver"
    }
    user_data = "${file("init.sh")}"
}

output "instance_publicdns" {
    value = aws_instance.webserver.public_dns
}

output "ip" {
  value = aws_instance.webserver.public_ip
}