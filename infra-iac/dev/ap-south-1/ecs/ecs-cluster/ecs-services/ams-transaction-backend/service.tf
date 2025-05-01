resource "aws_cloudwatch_log_group" "log-group" {
  name = "${terraform.workspace}-${var.service_name}-logs"
  retention_in_days = 14 # expected retention_in_days to be one of [0 1 3 5 7 14 30 60 90 120 150 180 365 400 545 731 1096 1827 2192 2557 2922 3288 3653]

  tags = {
    Service = var.service_name
    env = "${terraform.workspace}"
  }
}
resource "aws_ecr_repository" "ecr" {
  name                 = "${var.service_name}"
  tags = {
    Service = var.service_name
    env = "${terraform.workspace}"
  }
  
}
resource "aws_ecr_lifecycle_policy" "ecr_image_retention" {
  repository = aws_ecr_repository.ecr.name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${terraform.workspace}-${var.service_name}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${terraform.workspace}-${var.service_name}-container",
      "image": "${aws_ecr_repository.ecr.repository_url}:latest",
      "entryPoint": [],
      "environment": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.log-group.id}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${terraform.workspace}-${var.service_name}"
        }
      },
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 0
        }
      ],
      "cpu": 128,
      "memory": 256,
      "networkMode": "bridge"
    }
  ]
  DEFINITION

  requires_compatibilities = ["EC2"]
  network_mode             = "bridge"
  memory                   = "256"
  cpu                      = "128"

  tags = {
    Name        = "${terraform.workspace}-${var.service_name}-ecs-td"
    env         = "${terraform.workspace}"
  }
}
resource "aws_ecs_service" "aws-ecs-service" {
  name                 = "${terraform.workspace}-${var.service_name}-ecs-service"
  cluster              =  var.cluster_id
  task_definition      =  aws_ecs_task_definition.aws-ecs-task.arn
  #launch_type          = "EC2"
  scheduling_strategy  = "REPLICA"
  desired_count        = 1
  force_new_deployment = true

   ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }


  load_balancer {
    target_group_arn = var.service_arn
    container_name   = "${terraform.workspace}-${var.service_name}-container"
    container_port   = 3000
  }
  lifecycle {
    ignore_changes = [desired_count]
  }
  capacity_provider_strategy {
    capacity_provider = "${terraform.workspace}-${var.cluster_name}-cp"
    weight            = 1
    base              = 0
  }

  //depends_on = [aws_lb_listener.listener]
}