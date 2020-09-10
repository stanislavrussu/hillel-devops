variable "ecs_cluster_name" {
  type = string
}

variable "ecs_cluster_arn" {
  type = string
}

variable "alb_listener_arn" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "service_name" {
  type = string
}

# variable "tags" {
#   type = map(string)
# }