Terraform Module to provision an AWS VPC with two public subnets and two private subnets.

Not intended for production use. It is an example module.

It is just for showing how to create a publish module in Terraform Registry.

Usage:

```hcl

provider "aws" {
  region = "us-east-1"
}

module "aws_vpc" {
    source = "balaban1432/vpc/aws"
}
```