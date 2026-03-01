🚀 Flask & Express Deployment using AWS and Terraform

This project demonstrates deploying a Flask backend and an Express frontend in three different ways using AWS and Terraform.

📌 Part 1: Single EC2 Deployment

Both Flask (port 5000) and Express (port 3000) run on one EC2 instance.

Installed using user data script.

Accessible via EC2 public IP.

Access:

http://<EC2_Public_IP>:3000
http://<EC2_Public_IP>:5000

📌 Part 2: Separate EC2 Deployment

Flask and Express deployed on two different EC2 instances.

Custom VPC, subnets, and security groups configured.

Express communicates with Flask internally.

Both applications accessible via public IP.

📌 Part 3: Docker + ECS Deployment

Flask and Express containerized using Docker.

Images stored in ECR.

Deployed using ECS Fargate.

Application Load Balancer routes traffic:

/ → Express

/api/* → Flask

⚙ How to Deploy
terraform init
terraform plan
terraform apply

To destroy infrastructure:

terraform destroy
🛠 Technologies Used

AWS (EC2, VPC, ECR, ECS, ALB)

Terraform

Docker

Flask

Express

⚠ Important

.terraform and .tfstate files are ignored.

Always run terraform destroy after testing to avoid charges.

👨‍💻 Created by Shubham
DevOps | AWS | Terraform
