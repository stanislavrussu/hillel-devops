variable "cluster_name" {
  type        = string
  description = "Name of ECS cluster to be used"
}

variable "tags" {
  type        = map(string)
  description = "Default tags for resources"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for ECS cluster"
}

variable "ec2_sg_list" {
  type        = list(string)
  description = "List of security groups to be attached to EC2 instance in cluster"
}

variable "subnets_id_list" {
  type        = list(string)
  description = "List of subnets where EC2 instance should be created"
}

variable "public_key" {
  type = string
}