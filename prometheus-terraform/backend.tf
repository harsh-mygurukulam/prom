terraform {
  backend "s3" {
    bucket = "my-websitej"  
    key    = "prometheus/terraform.tfstate" 
    region = "eu-north-1"                    
    encrypt = true                        
  }
}
