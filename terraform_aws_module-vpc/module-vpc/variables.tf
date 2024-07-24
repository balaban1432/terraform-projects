variable "owner" {
    default = "balaban-example-vpc"  
}

variable "vpc_cidr_block" {
    default = "90.90.0.0/16"  
}

variable "public_subnet1_cidr" {
    default = "90.90.10.0/24"  
}

variable "public_subnet2_cidr" {
    default = "90.90.20.0/24"  
}

variable "private_subnet1_cidr" {
    default = "90.90.11.0/24"  
}

variable "private_subnet2_cidr" {
    default = "90.90.21.0/24"  
}

variable "vpc-region" {
    default = "us-east-2"  
}