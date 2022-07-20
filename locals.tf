locals {
  bucket               = var.name
  use_prefix           = var.use_prefix
  labels               = var.labels
  sse_config           = var.server_side_encryption_configuration
  acl                  = var.acl
  versioning           = var.versioning
  prefix               = var.logging_prefix != null ? var.logging_prefix : "${local.bucket}/"
  cors_rule            = var.cors_rule
  roles                = var.roles
  groups               = var.groups
  bucket_name          = (var.name_override || local.labels == null) ? local.bucket : "${local.labels.id}-${local.bucket}"
  suppress_iam         = var.suppress_iam
  public_access_block  = { for k, v in var.public_access_block : k => v == null ? false : v }
  force_destroy        = var.force_destroy
  RW_policy_conditions = var.policy_conditions.RW == tomap(null) ? {} : var.policy_conditions.RW
  RO_policy_conditions = var.policy_conditions.RO == tomap(null) ? {} : var.policy_conditions.RO
  bucket_policy        = var.bucket_policy

  logging = var.logging == null ? {} : {
    logging = {
      bucket = var.logging
      prefix = local.prefix
  } }
}
