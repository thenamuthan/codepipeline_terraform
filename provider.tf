provider "aws" {
  region = var.AWS_REGION

}
provider "github" {
  token = var.GITHUB_TOKEN
}

data "aws_availability_zones" "available" {
  state = "available"

}
data "aws_caller_identity" "current" {

}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

