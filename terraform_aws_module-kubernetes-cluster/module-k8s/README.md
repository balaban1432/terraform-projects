Terraform Module to provision a Kubernetes Cluster with version 1.29 on Ubuntu 22.04 of EC2 Instances.

Kubernetes cluster comprises of one master node and one worker node.
 
Once the Master node is up and running, Worker node automatically joins the Cluster.

Managers security group allows all protocols from all ports within itself and from the Workers. Workers security group allows all protocols from all ports within itself and from the Managers. Both Security groups allows SSH (22) connections from anywhere.
  
This module is designed for us-east-1 (N. Virginia) region. If you work on another region, do not forget to change instances imageId

Not intended for production use. It is an example module.

Usage:

```hcl

provider "aws" {
  region = "us-east-1"
}

module "aws_vpc" {
    source = "balaban1432/kubernetes-cluster/aws"
    key_name = "example"
}
```