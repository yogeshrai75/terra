
terraform {
  backend "s3" {
    bucket         = "r2admin1234-2f6a9037"           # Replace with the bucket name from the first apply
    key            = "terraform/state/vpc.tfstate"
    region         = "ap-south-1"
    profile        = "default"
  }
}


