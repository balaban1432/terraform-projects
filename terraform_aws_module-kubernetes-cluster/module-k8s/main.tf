data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_instance" "master" {
  ami                  = var.instance_ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2connectprofile.name
  user_data            = file("${abspath(path.module)}/master.sh")
  vpc_security_group_ids = [aws_security_group.tf-k8s-master-sec-gr.id]
  tags = {
    Name = "${var.owner}-kube-master"
  }
}

resource "aws_instance" "worker" {
  ami                  = var.instance_ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2connectprofile.name
  vpc_security_group_ids = [aws_security_group.tf-k8s-master-sec-gr.id]
  user_data            = templatefile("${abspath(path.module)}/worker.sh", { region = data.aws_region.current.name, master-id = aws_instance.master.id, master-private = aws_instance.master.private_ip} )
  tags = {
    Name = "${var.owner}-kube-worker"
  }
  depends_on = [aws_instance.master]
}

resource "aws_iam_instance_profile" "ec2connectprofile" {
  name = "ec2connectprofile-${var.owner}"
  role = aws_iam_role.ec2connectcli.name
}

resource "aws_iam_role" "ec2connectcli" {
  name = "ec2connectcli-${var.owner}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "my_inline_policy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          "Effect" : "Allow",
          "Action" : "ec2-instance-connect:SendSSHPublicKey",
          "Resource" : "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*",
          "Condition" : {
            "StringEquals" : {
              "ec2:osuser" : "ubuntu"
            }
          }
        },
        {
          "Effect" : "Allow",
          "Action" : "ec2:DescribeInstances",
          "Resource" : "*"
        }
      ]
    })
  }
}

resource "aws_security_group" "tf-k8s-master-sec-gr" {
  name = "${var.owner}-k8s-master-sec-gr"
  tags = {
    Name = "${var.owner}-k8s-master-sec-gr"
  }

  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    self = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
