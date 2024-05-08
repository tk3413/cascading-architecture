terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ecs_task_definition" "tkpythontemplate" {
  task_definition = aws_ecs_task_definition.tkpythontemplate.family
}


resource "aws_ecs_task_definition" "tkpythontemplate" {
  family                   = "tkpythontemplate"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  task_role_arn            = "arn:aws:iam::065455251419:role/ecsTaskExecutionRole"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = "arn:aws:iam::065455251419:role/ecsTaskExecutionRole"
  container_definitions = <<DEFINITION
[
  {
    "name": "tkpythontemplate",
    "essential": true,
    "image": "tk3413/tk-python-template:latest",
    "taskRoleArn": "arn:aws:iam::065455251419:role/ecsTaskExecutionRole",
    "operating_system_family": "LINUX",
    "command": [],
    "entrypoint": [],
    "portMappings": [
      {
        "hostPort": 8081,
        "protocol": "tcp",
        "containerPort": 8081
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/ecs/tk-python-template",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
  }
]
DEFINITION
  runtime_platform {
    operating_system_family = "LINUX"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

data "aws_lb" "tklb" {
  name = "tk-lb"
}

resource "aws_ecs_service" "tkpythontemplate" {
  name          = "tkpythontemplate"
  cluster       = "arn:aws:ecs:us-east-1:065455251419:cluster/tkcluster"
  desired_count = 1
  launch_type = "FARGATE"
  network_configuration {
    subnets = ["subnet-3ef04c74"]
    security_groups = ["sg-8a2a35c3"]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tkpythontemplate.arn
    container_name = "tkpythontemplate"
    container_port = 8081
  }

  # Track the latest ACTIVE revision
  task_definition = data.aws_ecs_task_definition.tkpythontemplate.arn
}

resource "aws_lb_target_group" "tkpythontemplate" {
  name     = "tk-python-template-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-90d38eeb"
  target_type = "ip"
  health_check {
    matcher = "200,202"
    path = "/tkpythontemplate/health"
  }
}

data "aws_lb_listener" "tklblistener443" {
  load_balancer_arn = data.aws_lb.tklb.arn
  port = 443
}

resource "aws_lb_listener_rule" "tkpythontemplaterule" {

  listener_arn = data.aws_lb_listener.tklblistener443.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tkpythontemplate.arn
  }
  condition {
    path_pattern {
      values = ["/tkpythontemplate/*"]
    }
  }
}

resource "aws_cloudwatch_log_group" "tkpythontemplate" {
  name = "/ecs/tk-python-template"
}
