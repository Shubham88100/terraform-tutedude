#Create VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags = {
        name = "main-vpc"
    }
}

#Create Subnet
resource "aws_subnet" "public_subnet1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"
    tags = {
        name = "public-subnet1"
    }
}

resource "aws_subnet" "public_subnet2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1b"
    tags = {
        name = "public-subnet2"
    }
}

#Create Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

#Create Route Table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

#Create Route Table Association
resource "aws_route_table_association" "public_subnet1_association" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_subnet2_association" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_rt.id
}


#Create Security Groups
resource "aws_security_group" "ecs_sg" {
    name = "ecs_sg"
    vpc_id = aws_vpc.main.id

     ingress {
      from_port = 5000
      to_port = 5000
      protocol = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
    }

     ingress {
      from_port = 3000
      to_port = 3000
      protocol = "tcp"
      security_groups = [aws_security_group.alb_sg.id]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

}


#Create Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name   = "alb-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
