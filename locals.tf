locals {
  name                 = var.name
  use_prefix           = var.use_prefix
  labels               = var.labels
  sse_algorithm        = var.sse_algorithm
  acl                  = var.acl
  versioning           = var.versioning
  prefix               = var.logging_prefix != null ? var.logging_prefix : "${local.name}/"
  cors_rule            = var.cors_rule
  roles                = var.roles
  groups               = var.groups
  suppress_iam         = var.suppress_iam
  public_access_block  = { for k, v in var.public_access_block : k => v == null ? false : v }
  force_destroy        = var.force_destroy
  RW_policy_conditions = var.policy_conditions.RW == tomap(null) ? {} : var.policy_conditions.RW
  RO_policy_conditions = var.policy_conditions.RO == tomap(null) ? {} : var.policy_conditions.RO


  logging = var.logging == null ? {} : {
    logging = {
      bucket = var.logging
      prefix = local.prefix
  } }

  config_unique_id = defaults(var.config_unique_id, {
    enable        = true
    length        = 8
    enable_suffix = !local.use_prefix
  })
}
