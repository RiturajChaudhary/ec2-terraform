terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Pin to the 5.x series
    }
  }
}

provider "aws" {
  region = var.aws_region
}
