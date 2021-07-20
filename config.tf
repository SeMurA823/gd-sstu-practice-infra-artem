provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
      bucket = "191274-petclinic-terraform-state-bucket"
      key = "191274/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "191274-terraform-state-table"
      encrypt = true
  }
}
