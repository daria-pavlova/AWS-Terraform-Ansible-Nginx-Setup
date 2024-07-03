terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.55.0"
    }
  }
  backend "s3" {
    bucket = "nginx-ec2"
    key    = "terraform/state/dev/nginx-ec2/0_teraform_service_user"
    region = "us-east-1"
  }
  
}
provider "aws" {
  profile = "default"
  region  = var.region

  default_tags {
    tags = {
      env = "dev"
      app = "exchange rate"
    }
  }
}


resource "aws_iam_user" "terraform_infra_user" {
  name = "terraform-infra-user"
}

resource "aws_iam_access_key" "terraform_infra_user_key" {
  user = aws_iam_user.terraform_infra_user.name
}

resource "aws_iam_user_policy_attachment" "terraform_infra_policy_attach" {
  user       = aws_iam_user.terraform_infra_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "terraform_infra_user_access_key_id" {
  value = aws_iam_access_key.terraform_infra_user_key.id
}

output "terraform_infra_user_secret_access_key" {
  value     = aws_iam_access_key.terraform_infra_user_key.secret
  sensitive = true
}
