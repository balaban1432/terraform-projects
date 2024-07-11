terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }

  backend "s3" {
    bucket = "tf-remote-s3-bucket-derya"
    key = "env/dev/tf-remote-backend.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf-s3-app-lock"
    encrypt = true
  }
}

resource "aws_s3_bucket" "tf-test-1" {
  bucket = "derya-test-1-versioning"
}

resource "aws_s3_bucket" "tf-test-2" {
  bucket = "derya-test-2-locking-2"
}