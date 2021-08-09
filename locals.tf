locals {
  bucket        = var.name
  use_prefix    = var.use_prefix
  labels        = var.labels
  sse_algorithm = var.sse_algorithm
  acl           = var.acl
  versioning    = var.versioning
  prefix        = var.logging_prefix != null ? var.logging_prefix : "${local.bucket}/"
  cors_rule     = var.cors_rule != null ? [var.cors_rule] : []
  roles         = var.roles
  groups        = var.groups
  bucket_name   = local.labels != null ? "${local.labels}-${local.bucket}" : local.bucket

  logging = tobool(var.logging) == false ? [] : [{
    bucket = tostring(var.logging)
    prefix = prefix
  }]
}
