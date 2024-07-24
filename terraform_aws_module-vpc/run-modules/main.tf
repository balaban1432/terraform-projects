module "vpc" {
  source  = "balaban1432/vpc/aws"
  version = "0.0.1"
  owner = "balaban"
}

output "vpc_cidr" {
    value = module.vpc.vpc_cidr  
}

output "vpc_id" {
    value = module.vpc.vpc_id  
}