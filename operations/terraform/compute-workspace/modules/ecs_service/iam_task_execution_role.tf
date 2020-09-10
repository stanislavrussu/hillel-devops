data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "task_execution_role" {
  name = "ECS-${var.ecs_cluster_name}-${var.service_name}-TaskExecutionRole"
  # tags               = var.tags
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


data "aws_iam_policy_document" "task_execution_role_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameters"
    ]
    resources = ["*"]
  }
}
resource "aws_iam_policy" "task_execution_role_policy" {
  name        = "${var.ecs_cluster_name}-${var.service_name}-TaskExecutionRolePolicy"
  path        = "/"
  description = "${var.ecs_cluster_name}-${var.service_name}-TaskExecutionRolePolicy"

  policy = data.aws_iam_policy_document.task_execution_role_policy.json
}


resource "aws_iam_role_policy_attachment" "attachment_task_execution_role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}