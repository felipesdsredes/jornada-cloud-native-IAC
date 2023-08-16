# Definições do cluster ECS para a demo

resource "aws_ecs_capacity_provider" "provider" {
  name = "alma"
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.failure_analysis_ecs_asg.arn

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "providers" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.provider.name]
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "cluster-jornada-demo"
}

# Definições do container da aplicação de front-end

resource "aws_ecs_task_definition" "front" {
  family = "front"
  container_definitions = jsonencode([
    {
      essential   = true
      memory      = 512
      name        = "front"
      cpu         = 1
      image       = "243551904600.dkr.ecr.us-east-1.amazonaws.com/front:latest"
      environment = []
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "front" {
  name            = "front"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.front.arn
  desired_count   = 1
}

# Definições do container da aplicação de back-end

resource "aws_ecs_task_definition" "back" {
  family = "back"
  container_definitions = jsonencode([
    {
      essential   = true
      memory      = 512
      name        = "back"
      cpu         = 1
      image       = "243551904600.dkr.ecr.us-east-1.amazonaws.com/back:latest"
      environment = []
      portMappings = [
        {
          containerPort = 3333
          hostPort      = 3333
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "back" {
  name            = "back"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.back.arn
  desired_count   = 1
}
