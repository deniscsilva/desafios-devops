# Configura o provedor da AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

module "security_group" {
  source       = "./modules/security_group"
  ssh_location = var.ssh_location
}

module "ec2_instance" {
  source            = "./modules/ec2_instance"
  instance_type     = var.instance_type
  key_name          = var.key_name
  security_group_id = module.security_group.security_group_id
}