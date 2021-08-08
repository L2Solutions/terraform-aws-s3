locals {
  bucket        = var.name
  use_prefix    = var.use_prefix
  labels        = var.labels
  sse_algorithm = var.sse_algorithm
  acl           = var.acl
  versioning    = var.versioning
  logging       = var.logging != null ? [var.logging] : []
  cors_rule     = var.cors_rule != null ? [var.cors_rule] : []
  roles         = var.roles
  groups        = var.groups

  bucket_name = local.labels != null ? "${local.labels}-${local.bucket}" : local.bucket
}
