terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

variable "sec-gr-mutual" {
  default = "k8s-mutual-sec-group"
}

variable "sec-gr-k8s-master" {
  default = "k8s-master-sec-group"
}

variable "sec-gr-k8s-worker" {
  default = "k8s-worker-sec-group"
}

data "aws_vpc" "name" {
  default = true
}

resource "aws_security_group" "mutual-sec-grp" {
  name        = var.sec-gr-mutual
  vpc_id      = data.aws_vpc.name.id

  ingress {
    from_port        = 2379
    to_port          = 2380
    protocol         = "tcp"
    self = true
  }

  ingress {
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    self = true
  }  

    ingress {
    protocol = "udp"
    from_port = 8472
    to_port = 8472
    self = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "kube-mutual-sec-grp"
  }
}

resource "aws_security_group" "kube-master-sg" {
  name = var.sec-gr-k8s-master
  vpc_id = data.aws_vpc.name.id

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 6443
    to_port = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 10257
    to_port = 10257
    self = true
  }

  ingress {
    protocol = "tcp"
    from_port = 10259
    to_port = 10259
    self = true
  }

  ingress {
    protocol = "tcp"
    from_port = 30000
    to_port = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "kube-master-secgroup"
  }
}

resource "aws_security_group" "kube-worker-sg" {
  name = var.sec-gr-k8s-worker
  vpc_id = data.aws_vpc.name.id


  ingress {
    protocol = "tcp"
    from_port = 30000
    to_port = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress{
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kube-worker-secgroup"
  }
}

resource "aws_instance" "kube-master" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t3a.medium"
    vpc_security_group_ids = [aws_security_group.petclinic-kube-master-sg.id, aws_security_group.petclinic-mutual-sg.id]
    key_name = "derya-key"
    subnet_id = "subnet-0b78f6926d3c44f8f"  # select own subnet_id of us-east-1b
    availability_zone = "us-east-1b"
    tags = {
        Name = "kube-master"
        Role = "master"
        Id = "1"
    }
}

resource "aws_instance" "worker-1" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t3a.medium"
    vpc_security_group_ids = [aws_security_group.petclinic-kube-worker-sg.id, aws_security_group.petclinic-mutual-sg.id]
    key_name = "derya-key"
    subnet_id = "subnet-0b78f6926d3c44f8f"  # select own subnet_id of us-east-1b
    availability_zone = "us-east-1b"
    tags = {
        Name = "worker-1"
        Role = "worker"
        Id = "1"
    }
}

resource "aws_instance" "worker-2" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t3a.medium"
    vpc_security_group_ids = [aws_security_group.petclinic-kube-worker-sg.id, aws_security_group.petclinic-mutual-sg.id]
    key_name = "derya-key"
    subnet_id = "subnet-0b78f6926d3c44f8f"  # select own subnet_id of us-east-1b
    availability_zone = "us-east-1b"
    tags = {
        Name = "worker-2"
        Role = "worker"
        Id = "2"
    }
}

output kube-master-ip {
  value       = aws_instance.kube-master.public_ip
  sensitive   = false
  description = "public ip of the kube-master"
}

output worker-1-ip {
  value       = aws_instance.worker-1.public_ip
  sensitive   = false
  description = "public ip of the worker-1"
}

output worker-2-ip {
  value       = aws_instance.worker-2.public_ip
  sensitive   = false
  description = "public ip of the worker-2"
}