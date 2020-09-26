variable "s3_bucket_name" {
  type        = string
  default     = "hw22russu"
  description = "S3 bucket to be used for static webhosting"
}

variable "tags" {
  type = map
  default = {
    "Project"     = "Conduit",
    "Environment" = "Development"
  }
  description = "Default tags for resources"
}

variable "arn" {
  type = string
}

variable "domain_name" {
  type    = string
  default = "stanislav.tiab.tech"
}

variable "id" {
  type    = string
}
