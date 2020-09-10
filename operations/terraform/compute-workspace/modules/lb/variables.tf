variable "acm_certificate_arn" { type = string }

variable "lb_name" { type = string }

variable "alb_sg_list" { type = list(string) }

variable "subnets_id_list" { type = list(string) }

variable "tags" { type = map(string) }

variable "domain_name" { type = string }