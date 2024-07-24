variable "owner" {
    type = string
    default = "balaban"  
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3a.medium"
}

variable "instance_ami" {
  type = string
  default = "ami-0c7217cdde317cfec"
}