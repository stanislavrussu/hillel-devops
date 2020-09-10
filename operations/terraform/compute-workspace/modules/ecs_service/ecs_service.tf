resource "aws_ecr_repository" "this" {
  name = "${var.ecs_cluster_name}-${var.service_name}"
  # tags = var.tags
}

resource "aws_lb_target_group" "this" {
  name                 = "${var.ecs_cluster_name}-${var.service_name}"
  port                 = 3000
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    path = "/api/tags"
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.alb_listener_arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
  condition {
    path_pattern {
      values = ["/api*"]
    }
  }
}

data "aws_iam_role" "ecs_service_role" {
  name = "AWSServiceRoleForECS"
}

data "aws_ssm_parameter" "MONGODB_URI" {
  name = "MONGODB_URI"
}

data "aws_ssm_parameter" "NODE_ENV" {
  name = "NODE_ENV"
}

data "aws_ssm_parameter" "SECRET" {
  name = "SECRET"
}

resource "aws_ecs_task_definition" "this" {
  family = var.service_name
  container_definitions = templatefile("${path.module}/task_definition.tmlp",
    {
      "image_uri"    = aws_ecr_repository.this.repository_url,
      "service_name" = var.service_name,
      "MONGODB_URI"  = data.aws_ssm_parameter.MONGODB_URI.arn,
      "NODE_ENV"     = data.aws_ssm_parameter.NODE_ENV.arn,
      "SECRET"       = data.aws_ssm_parameter.SECRET.arn
    }
  )
  execution_role_arn = aws_iam_role.task_execution_role.arn
  network_mode       = "bridge"
  # tags = var.tags
}

resource "aws_ecs_service" "this" {
  name                               = var.service_name
  cluster                            = var.ecs_cluster_arn
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  desired_count                      = 1
  health_check_grace_period_seconds  = 10
  iam_role                           = data.aws_iam_role.ecs_service_role.arn
  launch_type                        = "EC2"
  task_definition                    = aws_ecs_task_definition.this.arn

  deployment_controller {
    type = "ECS"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.service_name
    container_port   = "3000"
  }
  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }
  depends_on = [aws_lb_listener_rule.this, aws_iam_role.task_execution_role]
}
