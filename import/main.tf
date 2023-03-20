terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "tf-sg" {
  name = "tf-import-sg"
  description = "terraform import security group"
  tags = {
    Name = "tf-import-sg"
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "tf-ami" {
  type = list(string)
  default = ["ami-005f9685cb30f234b", "ami-0557a15b87f6559cf", "ami-0c9978668f8d55984"]
}

variable "tf-tags" {
  type = list(string)
  default = ["aws-linux-2", "ubuntu-22.04", "red-hat-linux-8"]
}

resource "aws_instance" "tf-instances" {
  ami = element(var.tf-ami, count.index )
  instance_type = "t2.micro"
  count = 3
  key_name = "derya-key"            // change here
  security_groups = ["tf-import-sg"]
  tags = {
    Name = element(var.tf-tags, count.index )
  }
}