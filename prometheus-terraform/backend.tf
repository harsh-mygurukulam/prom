terraform {
  backend "s3" {
    bucket         = "promtheus-harsh-bucket"
    key            = "prod/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "mytable"
    encrypt        = true
  }
}
