module "terraform-my-vpc" {
    source = "../module_vpc"
    vpc-region = "us-east-1"
    owner = "balaban"  
}

output "vpc-cidr" {
    value = module.terraform-my-vpc.vpc_cidr  
}

output "vpc-id" {
    value = module.terraform-my-vpc.vpc_id  
}

output "vpc-tags" {
    value = module.terraform-my-vpc.vpc_tags  
}