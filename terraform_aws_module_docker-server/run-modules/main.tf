provider "aws" {
  region = "us-east-1"
}

module "docker-instance" {
  source  = "balaban1432/docker-instance/aws"
  version = "0.0.1"
  # insert the 1 required variable here
  key_name = "derya"
  server-name = "balaban-docker-instance"
}

output "public_ip" {
    value = module.docker-instance.instance_public_ip.*
}