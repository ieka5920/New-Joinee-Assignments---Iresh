provider "aws" {
  region = "us-east-1" 
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-bucket-assignemntq01"

  tags = {
    Name = "terraform-state-bucket-assignemntq01"
    Task = "assignemntq01"
  }
}

resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-state-lock-assignemntq01"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-state-lock-assignemntq01"
    Task = "assignemntq01"
  }
}
