variable ami_id {
  type = string
  # default     = ""
  description = "ID of the AMI in a format 'ami-1z2x3c4v5b6m'"
  validation {
    condition     = can(regex("^ami-", var.ami_id))
    error_message = "Must be an AMI id, starting with \"ami-\"."
  }
}

variable instance_type {
  type        = string
  default     = ""
  description = "Insatnce type to be used, for example 't2.micro'"
}

variable eip_attach {
  type        = bool
  default     = false
  description = "Selector for ElasticIP: true == create and attach"
}

variable size {
  type        = number
  default     = 1
  description = "(Optional) The size of the drive in GiBs"
}
