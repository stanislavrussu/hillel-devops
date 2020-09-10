output "aws_ecr_repository" {
  value = aws_ecr_repository.this.repository_url
}

output "aws_ecs_service_name" {
  value = aws_ecs_service.this.name
}