locals {
  bucket_name = (var.name_override || local.labels == null) ? var.name : "${local.labels.id}-${var.name}"
  labels      = var.labels
  use_prefix  = var.use_prefix

  roles = defaults(var.roles, {
    mode = "ro"
  })

  groups = defaults(var.groups, {
    mode = "ro"
  })

  sse_config        = var.server_side_encryption_configuration
  acl               = var.acl
  enable_versioning = var.enable_versioning

  public_access_block = defaults(var.public_access_block, {
    block_public_policy     = true,
    block_public_acls       = true,
    restrict_public_buckets = true,
    ignore_public_acls      = true,
  })

  config_cors = defaults(var.config_cors, {
    rules = {}
  })

  config_iam = defaults(var.config_iam, {
    enable            = true,
    bucket_policy     = "",
    policy_conditions = {}
  })

  config_logging = defaults(var.config_logging, {
    buckets = {
      target_prefix = "${local.bucket_name}/"
    }
  })

  force_destroy = var.force_destroy
}
