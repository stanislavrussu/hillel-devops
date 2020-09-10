variable "profile" {
  type        = string
  default     = "default"
  description = "Default profile name"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "ami_id" {
  type        = string
  default     = "ami-0bcc094591f354be2"
  description = "ID of the AMI in a format 'ami-0bcc094591f354be2'"
  validation {
    condition     = can(regex("^ami-", var.ami_id))
    error_message = "Must be an AMI id, starting with \"ami-\"."
  }
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Insatnce type to be used, for example 't2.micro'"
  validation {
    condition     = can(regex("^[[:lower:]]", var.instance_type))
    error_message = "Must be an Instance Type, starting with \"lowercase letter\", for example 't2.micro'."
  }
}

variable "domain_name" {
  type    = string
  default = "stanislav.tiab.tech"
}

variable "vpc_cidr" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Default tags"
}

variable "public_key" {
  type = string
}

variable "service_name" {
  type = string
}

#variable "s3_bucket_name" {
#  type        = string
#  description = ""
#}