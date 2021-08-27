variable "name" {
  type        = string
  description = "The name of the s3 bucket"
}

variable "use_prefix" {
  type        = bool
  description = "Use var.name as name prefix instead"
  default     = true
}

variable "name_override" {
  type        = bool
  description = "Name override the opionated name variable"
  default     = false
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
  description = "Pass null to disable logging or pass the logging bucket id"
  type        = string
}

variable "logging_prefix" {
  description = "Will default to /{name}"
  type        = string
  default     = null
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

variable "supress_iam" {
  description = "Supresses the module creating iam resources if none are needed"
  type        = bool
  default     = false
}