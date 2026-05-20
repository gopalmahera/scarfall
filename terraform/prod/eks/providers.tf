terraform {
  required_version = ">= 1.5.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.9"
    }
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "az" {
  state = "available"
}

provider "aws" {
  region = var.region
}
