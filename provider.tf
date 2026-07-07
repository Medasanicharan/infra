terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  # Backend is intentionally left partial. Environment-specific values
  # (bucket/key/region) are supplied at `terraform init` time via
  # -backend-config=envs/<env>/backend.tf, so the same code targets
  # multiple isolated state files - one per environment.
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}
