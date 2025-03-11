terraform {
  backend "s3" {
    bucket = "promtheus-harsh-bucket"  
    key    = "prometheus/terraform.tfstate" 
    region = "eu-north-1"                    
    encrypt = true                        
  }
}
