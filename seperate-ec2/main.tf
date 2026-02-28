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

#Create AWS VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
}

#Create Subnet
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
}

#Create Internet Gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
}

#Create Route Table
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet_access" {
    route_table_id = aws_route_table.rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.rt.id
}

#Flask security group
resource "aws_security_group" "flask_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
      from_port = 5000
      to_port = 5000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 22
      to_port = 22
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

#Express security group
resource "aws_security_group" "express_sg" {
    vpc_id = aws_vpc.main.id

    ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 22
      to_port = 22
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

#Flask EC2
resource "aws_instance" "flask" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
    key_name = "course-tutedude" 
    subnet_id = aws_subnet.public.id
    security_groups = [aws_security_group.flask_sg.id]

    user_data = file("flask.sh")
}

#Express EC2
resource "aws_instance" "express" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
    key_name = "course-tutedude" 
    subnet_id = aws_subnet.public.id
    security_groups = [aws_security_group.express_sg.id]

    user_data = templatefile("${path.module}/express.sh.tpl",{
        flask_private_ip = aws_instance.flask.private_ip
    })
}

