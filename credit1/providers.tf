terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "cscie49-terraform-state-bucket"
    key    = "credit1"
    region = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.region}"
}



# locals {
#   cluster_name = "education-eks-${random_string.suffix.result}"
# }
