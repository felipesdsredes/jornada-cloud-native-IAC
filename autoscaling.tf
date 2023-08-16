# Definição do template de criação da instância EC2

resource "aws_launch_template" "engine" {
  name          = "alma"
  image_id      = "ami-05339d597592d45cf" # Amazon ECS-Optimized Amazon Linux 2 (AL2) x86_64 AMI
  instance_type = "t2.medium"
  user_data     = base64encode("#!/bin/bash\necho ECS_CLUSTER=cluster-jornada-demo >> /etc/ecs/ecs.config")

  vpc_security_group_ids = [aws_security_group.ecs_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }

}

# Definição do grupo de autoscaling

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name                = "asg"
  vpc_zone_identifier = [aws_subnet.pub_subnet.id]

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"

  launch_template {
    id = aws_launch_template.engine.id
  }
}
