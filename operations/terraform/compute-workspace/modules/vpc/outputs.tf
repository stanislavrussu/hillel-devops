output "vpc" {
  value = aws_vpc.this
}

output "subnets_id_list" {
  value       = [for subnet in aws_subnet.this : subnet.id]
  description = "List of subnets to be used for services"
}

output "ec2_sg_list" {
  value = [aws_vpc.this.default_security_group_id]
}

output "alb_sg_list" {
  value = [aws_vpc.this.default_security_group_id, aws_security_group.web_access.id]
}

output "vpc_id" {
  value = aws_vpc.this.id
}