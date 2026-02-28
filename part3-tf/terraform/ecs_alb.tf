#Create Application LoadBalancer (ALB)
resource "aws_lb" "app_alb" {
    name = "app-alb"
    internal = false
    load_balancer_type = "application"
    subnets = [
        aws_subnet.public_subnet1.id,
        aws_subnet.public_subnet2.id
    ]
    security_groups = [aws_security_group.ecs_sg.id]
}



#Target Groups for Flask & Express
resource "aws_lb_target_group" "flask_tg" {
    name = "flask-tg"
    port = 5000
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    target_type = "ip"
    health_check {
        path = "/api/hello"
        protocol = "HTTP"
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
        matcher = "200"
    }
}

resource "aws_lb_target_group" "express_tg" {
    name = "express-tg"
    port = 3000
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    target_type = "ip"
    health_check {
        path = "/"
        protocol = "HTTP"
        interval = 30
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 2
        matcher = "200"
    }
}

#Create Listener
resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.app_alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.express_tg.arn
    }
}

#Listener Rules for Flask
resource "aws_lb_listener_rule" "flask_rule" {
    listener_arn = aws_lb_listener.http_listener.arn
    priority = 10
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.flask_tg.arn
    }
    condition {
        path_pattern {
            values = ["/api/*"]
        }
    }
}

#Listener Rules for Express
resource "aws_lb_listener_rule" "express_rule" {
    listener_arn = aws_lb_listener.http_listener.arn
    priority = 20
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.flask_tg.arn
    }
    condition {
        path_pattern {
            values = ["/*"]
        }
    }
}

#Create ECS Services for Flask & Express
resource "aws_ecs_service" "flask_service" {
    name = "flask-service"
    cluster = aws_ecs_cluster.app_cluster.id
    task_definition = aws_ecs_task_definition.flask_task.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = [
            aws_subnet.public_subnet1.id,
            aws_subnet.public_subnet2.id
        ]
        security_groups = [aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.flask_tg.arn
        container_name = "flask"
        container_port = 5000
    }
}

resource "aws_ecs_service" "express_service" {
    name = "express-service"
    cluster = aws_ecs_cluster.app_cluster.id
    task_definition = aws_ecs_task_definition.express_task.arn
    desired_count = 1
    launch_type = "FARGATE"
    network_configuration {
        subnets = [
            aws_subnet.public_subnet1.id,
            aws_subnet.public_subnet2.id
        ]
        security_groups = [aws_security_group.ecs_sg.id]
        assign_public_ip = true
    }

    load_balancer {
      target_group_arn = aws_lb_target_group.express_tg.arn
      container_name = "express"
      container_port = 3000
    }

    depends_on = [aws_lb_listener.http_listener]
}