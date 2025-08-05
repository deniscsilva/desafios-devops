terraform {
  backend "s3" {
    bucket  = "dcs-desafio-devops"
    key     = "terraform/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
