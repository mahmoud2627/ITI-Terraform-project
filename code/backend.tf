

terraform {
  backend "s3" {
    bucket         = "bucket-test-end"
    key            = "tfstate"
    region         = "us-east-2"
    dynamodb_table = "tf-lock-state"
  }
} 
