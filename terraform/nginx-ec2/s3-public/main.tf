terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.55.0"
    }
  }
  backend "s3" {
    bucket = "nginx-ec2"
    key    = "terraform/state/dev/nginx-ec2/2_s3"
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
      app = "public-s3-text-file"
    }
  }
}




# Route53
resource "aws_s3_bucket" "personal-code-challenge-s3-public-bucket" {
  bucket = "personal-code-challenge-s3-public-bucket"
  #add acl pulic to everyone
}

# resource "aws_s3_bucket_policy" "public_policy" {
#   depends_on = [aws_s3_bucket.personal-code-challenge-s3-public-bucket]
#   bucket = aws_s3_bucket.personal-code-challenge-s3-public-bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = "*",
#         Action = "s3:GetObject",
#         Resource = "arn:aws:s3:::personal-code-challenge-s3-public-bucket"
#       },
#     ]
#   })
# }


# resource "aws_s3_bucket_public_access_block" "public" {
#   bucket = aws_s3_bucket.personal-code-challenge-s3-public-bucket.id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_object" "upload_file" {
#   bucket = aws_s3_bucket.personal-code-challenge-s3-public-bucket.id
#   key    = "__cb__somefile"  # Replace with the desired key for the file in the bucket
#   source = "file.txt"  # Replace with the local path of the file you want to upload
# }

# resource "aws_s3_access_point" "example" {
#   bucket = aws_s3_bucket.personal-code-challenge-s3-public-bucket.id
#   name   = "public-internet-access-point"
#   public_access_block_configuration {
#     block_public_acls       = false
#     block_public_policy     = false
#     ignore_public_acls      = false
#     restrict_public_buckets = false
#   }
# }