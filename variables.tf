variable "name" {
  type        = string
  description = "The name of the s3 bucket"
}

variable "use_prefix" {
  type        = bool
  description = "Use var.bucket as name prefix instead"
  default     = true
}

variable "labels" {
  type = object({
    id = string
  })
  description = "The labels module id"
  default     = null
}

variable "sse_algorithm" {
  default     = "AES256"
  description = "The encryption algorithm"
  type        = string
}

variable "acl" {
  description = "Bucket ACL"
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "Use bucket versioning"
  type        = bool
  default     = true
}

variable "logging" {
  description = "Logging bucket id and folder prefix"
  type = object({
    bucket = string
    prefix = string
  })
  default = null
}

variable "cors_rule" {
  description = "value"
  type        = map(any)
  default     = null
}

variable "groups" {
  description = "Group names to attach"
  type = list(object({
    name = string
    mode = string
  }))
  validation {
    condition     = alltrue([for x in var.groups : contains(["RW", "RO"], x.mode)])
    error_message = "Mode must be RW or RO."
  }

  default = []
}

variable "roles" {
  description = "Roles to attach"
  type = list(object({
    name = string
    mode = string
  }))
  validation {
    condition     = alltrue([for x in var.roles : contains(["RW", "RO"], x.mode)])
    error_message = "Mode must be RW or RO."
  }
  default = []
}
