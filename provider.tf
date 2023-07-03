provider "aws" {
  profile = "eksctl"
  region  = "us-east-1"

  access_key = "AKIAR25PCEOZVEFOO5YL"
  secret_key = "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"
}

variable "cluster_name" {
  default = "eks-cluster"
}

variable "cluster_version" {
  default = "1.25"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}