#creating backend s3
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = aws_s3_bucket.demo-artifacts
    key    = "terraform.tfstate"
    region = var.AWS_REGION
  }
}


