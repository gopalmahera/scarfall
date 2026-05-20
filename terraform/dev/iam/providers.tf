terraform {
  required_version = ">= 1.12.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0, < 7.0.0"
    }
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "az" {
  state = "available"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.region
}
