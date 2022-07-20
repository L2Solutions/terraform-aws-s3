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
  description = "Name override the opinionated name variable"
  default     = false
}

variable "labels" {
  description = "Instance of labels module"
  type = object(
    {
      id   = string
      tags = any
    }
  )
  default = {
    id   = ""
    tags = {}
  }
}

variable "server_side_encryption_configuration" {
  description = "Pass through to server_side_encryption_configuration. If null is passed for kms_master_key_id, will autocreate"
  type = object({
    type              = string
    kms_master_key_id = optional(string)
  })

  default = {
    kms_master_key_id = null
    type              = "aws:kms"
  }
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
  default     = null
}

variable "logging_prefix" {
  description = "Will default to /{name}"
  type        = string
  default     = null
}

variable "cors_rule" {
  description = "value"
  type = map(object({
    allowed_headers = optional(list(string))
    allowed_methods = optional(list(string))
    allowed_origins = optional(list(string))
    expose_headers  = optional(list(string))
  }))
  default = {}
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

variable "suppress_iam" {
  description = "Supresses the module creating iam resources if none are needed"
  type        = bool
  default     = false
}

variable "public_access_block" {
  type = object({
    block_public_policy     = optional(bool)
    block_public_acls       = optional(bool)
    restrict_public_buckets = optional(bool)
    ignore_public_acls      = optional(bool)
  })
  default = {}
}

variable "policy_conditions" {
  description = "Conditions on RO and RW policy"
  default     = {}
  type = object({
    RW = optional(map(object({
      test     = string
      variable = string
      values   = list(string)
    })))
    RO = optional(map(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  })
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy variable passed through to s3 resource"
}

variable "bucket_policy" {
  description = "The policy document directly on the bucket. Use `data.aws_iam_policy_document.<name>.json` here."
  type        = any
  default     = null
}
