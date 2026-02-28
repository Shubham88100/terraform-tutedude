terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

#Create ECR for Flask
resource "aws_ecr_repository" "flask_backend" {
    name = "flask-backend"
    force_delete = true
}
#Create ECR for Express
resource "aws_ecr_repository" "express_frontend" {
    name = "express-frontend"
    force_delete = true
}