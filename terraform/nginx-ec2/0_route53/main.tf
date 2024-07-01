terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.55.0"
    }
  }
  backend "s3" {
    bucket = "nginx-ec2"
    key    = "terraform/state/dev/nginx-ec2/0_route53"
    region = "us-east-1"
  }
  
}
provider "aws" {
  # access_key = var.ACCESS_KEY
  # secret_key = var.SECRET_KEY
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      env = "dev"
      app = "exchange rate"
    }
  }
}




# Route53
resource "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone
}

