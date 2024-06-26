terraform {
  required_version = ">= 1.8.5"  # Use the latest minor version that matches 1.8.x
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}


resource "random_id" "bucket_suffix" {
  byte_length = 4
}


resource "aws_s3_bucket" "s3bucket" {
  bucket = "${var.bucket_name}-${random_id.bucket_suffix.hex}"

 
  versioning {
    enabled = true
  }

  
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # Define tags for the S3 bucket
  tags = {
    Name        = "${var.bucket_name}-${random_id.bucket_suffix.hex}"
    Environment = var.environment
  }

  # Define a lifecycle rule (example: move objects to STANDARD_IA after 30 days and delete after 365 days)
  lifecycle_rule {
    enabled = true
    prefix  = ""

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365
    }
  }
}

# Define variables
variable "bucket_name" {
  description = "The base name of the S3 bucket. A unique suffix will be added."
  default     = "r2admin1234"
}

variable "environment" {
  description = "The environment for tagging the bucket (e.g., Dev, Prod)."
  default     = "Dev"
}

# Output the bucket name
output "bucket_name" {
  description = "The name of the created S3 bucket."
  value       = aws_s3_bucket.s3bucket.bucket
}

