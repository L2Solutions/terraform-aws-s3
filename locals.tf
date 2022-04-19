locals {
  bucket              = var.name
  use_prefix          = var.use_prefix
  labels              = var.labels
  sse_algorithm       = var.sse_algorithm
  acl                 = var.acl
  versioning          = var.versioning
  prefix              = var.logging_prefix != null ? var.logging_prefix : "${local.bucket}/"
  cors_rule           = var.cors_rule
  roles               = var.roles
  groups              = var.groups
  bucket_name         = (var.name_override || local.labels == null) ? local.bucket : "${local.labels.id}-${local.bucket}"
  suppress_iam        = var.suppress_iam
  public_access_block = { for k, v in var.public_access_block : k => v == null ? false : v }

  logging = var.logging == null ? {} : {
    logging = {
      bucket = var.logging
      prefix = local.prefix
  } }
}
