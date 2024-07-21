terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-assignemntq01"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-assignemntq01"
  }
}
