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

resource "aws_security_group" "app_sg" {
    name = "single-ec2-sg"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

      ingress {
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

      ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

      egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "express-flask" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
    key_name = "course-tutedude"
    security_groups = [aws_security_group.app_sg.name]
    user_data = file("app.sh")

    tags = {
        name = "single-ec2-express-flask"
    }
}

output "public_ip" {
    value = aws_instance.express-flask.public_ip
}


