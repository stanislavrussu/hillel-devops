variable "tags" {
  type        = map(string)
  description = "default tags to use"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block to be used for VPC"
}