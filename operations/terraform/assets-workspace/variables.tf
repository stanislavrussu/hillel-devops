variable "region" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "default tags"
}

variable "domain_name" {
  type        = string
  description = "(optional) describe your variable"
  # default = "stanislav.tiab.tech"
}