
#Create ECS Cluster
resource "aws_ecs_cluster" "app_cluster" {
    name = "app-cluster"
}

#Create IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
    name = "ecs-task-execution-role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy"{
    role = aws_iam_role.ecs_task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Create ECS Task Definition for Flask
resource "aws_ecs_task_definition" "flask_task" {
    family = "flask-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode ([{
        name = "flask"
        image = "934568646430.dkr.ecr.ap-south-1.amazonaws.com/flask-backend:latest"
        essential = true
        portMappings = [{containerPort = 5000, hostPort = 5000 , protocol = "tcp"}]
    }])
}

#Create ECS Task Definition for Express
resource "aws_ecs_task_definition" "express_task" {
    family = "express-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
    container_definitions = jsonencode ([{
        name = "express"
        image = "934568646430.dkr.ecr.ap-south-1.amazonaws.com/express-frontend:latest"
        essential = true
        portMappings = [{containerPort = 3000, hostPort = 3000 , protocol = "tcp"}]
    }])
}

