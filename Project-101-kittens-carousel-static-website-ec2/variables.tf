variable "aws_region" {
    default = "us-east-1"  
}

variable "instance_type" {
    description = "select your instance type"
    type = list(string)
    default = [ "t2.micro", "t2.nano", "t1.micro" ]
}

variable "instance_keypair" {
    description = "enter your key-pem"
    type = string
    default = "derya-key"
}
