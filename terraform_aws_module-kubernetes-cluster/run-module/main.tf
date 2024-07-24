module "kubernetes-cluster" {
  source  = "balaban1432/kubernetes-cluster/aws"
  version = "1.0.0"
  # insert the 1 required variable here
  key_name = "derya"
}

provider "aws" {
  region = "us-east-1"
}

output "master-public-ip" {
  value = module.kubernetes-cluster.master_public_ip
}