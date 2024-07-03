terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.55.0"
    }
  }
  backend "s3" {
    bucket = "nginx-ec2"
    key    = "terraform/state/dev/nginx-ec2/1_ec2"
    region = "us-east-1"
  }

}
provider "aws" {
  # profile = "default"
  region = var.region

  default_tags {
    tags = {
      env = "dev"
      app = "nginx-api"
    }
  }
}
# VPC
resource "aws_vpc" "nginx-api_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true

  tags = {
    Name = "tf-nginx-api-vpc"
  }
}

# Subnet
resource "aws_subnet" "nginx-api_subnet" {
  vpc_id                  = aws_vpc.nginx-api_vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone

  tags = {
    Name = "tf-nginx-api-subnet"
  }
}

resource "aws_internet_gateway" "nginx-api_gw" {
  vpc_id = aws_vpc.nginx-api_vpc.id

  tags = {
    Name = "tf-nginx-api-gw"
  }
}

resource "aws_route_table" "nginx-api_public_rtb" {
  vpc_id = aws_vpc.nginx-api_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nginx-api_gw.id
  }
  tags = {
    Name = "tf-nginx-api-public-rtb"
  }
}

resource "aws_route_table_association" "nginx-api_crta_public_subnet" {
  subnet_id      = aws_subnet.nginx-api_subnet.id
  route_table_id = aws_route_table.nginx-api_public_rtb.id
}

resource "aws_security_group" "nginx-api_security_group" {
  vpc_id = aws_vpc.nginx-api_vpc.id

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-nginx-api_security_group"
  }
}

resource "aws_key_pair" "aws-key" {
  key_name   = "aws-key"
  public_key = file(var.PUBLIC_KEY_PATH)
}

resource "aws_instance" "nginx-api_test_vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.nginx-api_subnet.id
  vpc_security_group_ids = ["${aws_security_group.nginx-api_security_group.id}"]
  key_name               = aws_key_pair.aws-key.id
  tags = {
    Name = "tf-nginx-api-test-vm"
  }
}

data "aws_route53_zone" "hosted_zone" {
  name = var.hosted_zone
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.hosted_zone.zone_id
}

resource "aws_route53_record" "a_record" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.hosted_zone
  type    = "A"
  ttl     = "300"
  records = aws_instance.nginx-api_test_vm.*.public_ip
}

resource "aws_iam_user" "nginx-api_user" {
  name          = var.user
  force_destroy = true
}

resource "aws_iam_user_login_profile" "nginx-api_user" {
  user = aws_iam_user.nginx-api_user.name
}

# Create access key
# resource "aws_iam_access_key" "nginx-api_user" {
#   user = aws_iam_user.nginx-api_user.name
# }

resource "aws_iam_group" "nginx-api_group" {
  name = var.group
}

resource "aws_iam_user_group_membership" "add_user" {
  user = aws_iam_user.nginx-api_user.name
  groups = [
    aws_iam_group.nginx-api_group.name
  ]
}

resource "aws_iam_policy" "nginx-api_policy" {
  name        = "tf_SG_Edit_permission"
  description = "Policy for editing security groups"
  policy      = var.custom_policy
}

resource "aws_iam_group_policy_attachment" "custom_policy_attach" {
  group      = aws_iam_group.nginx-api_group.name
  policy_arn = aws_iam_policy.nginx-api_policy.arn
}

resource "aws_iam_group_policy_attachment" "managet_policy_attach" {
  group      = aws_iam_group.nginx-api_group.name
  policy_arn = var.managet_policy
}