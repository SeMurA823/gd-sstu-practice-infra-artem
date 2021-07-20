resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "191274-petclinic-terraform-state-bucket"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform_state_table" {
    hash_key = "LockID"
    name = "191274-terraform-state-table"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
      name = "LockID"
      type = "S"
    }
}

resource "aws_s3_bucket" "scripts_bucket" {
  bucket = "191274-scripts-bucket"  
}

data "archive_file" "bastion_scripts" {
  type = "zip"
  source_dir = "./scripts/bastion/bastion-scripts"
  output_path = "./scripts/bastion/bastion-scripts.zip"
}

data "archive_file" "instance_scripts" {
  type = "zip"
  source_dir = "./scripts/ec2-instances/instance-scripts"
  output_path = "./scripts/ec2-instances/instance-scripts.zip"
}

resource "aws_s3_bucket_object" "scripts_bastion_upload" {
  bucket = aws_s3_bucket.scripts_bucket.id
  key = "bastion-scripts/bastion-scripts.zip"
  source = data.archive_file.bastion_scripts.output_path
}

resource "aws_s3_bucket_object" "scripts_instance_upload" {
  bucket = aws_s3_bucket.scripts_bucket.id
  key = "instance-scripts/instance-scripts.zip"
  source = data.archive_file.instance_scripts.output_path
}
