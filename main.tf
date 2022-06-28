module "labels" {
  source  = "skyfjell/label/null//modules/extend"
  version = "1.0.1"

  config = merge(
    local.labels,
    {
      name      = length(local.labels.name) == 0 ? local.name : local.labels.name
      component = length(local.labels.name) == 0 ? "" : local.name
    }
  )

  config_unique_id = local.config_unique_id
}

resource "aws_s3_bucket" "this" {
  // checkov:skip=CKV_AWS_144: Not yet supported
  // checkov:skip=CKV2_AWS_6: Moved to resource `aws_s3_bucket_public_access_block`
  // checkov:skip=CKV_AWS_21: User defined input
  // checkov:skip=CKV_AWS_18: User defined input
  // checkov:skip=CKV_AWS_145: User defined input
  // checkov:skip=CKV_AWS_19: User defined input
  bucket        = local.use_prefix ? null : module.labels.id
  bucket_prefix = local.use_prefix ? module.labels.id : null
  force_destroy = local.force_destroy

  tags = module.labels.tags
}

resource "aws_s3_bucket_cors_configuration" "this" {
  for_each = local.cors_rule
  bucket   = aws_s3_bucket.this.id

  cors_rule {
    allowed_headers = lookup(each.value, "allowed_headers", [])
    allowed_methods = lookup(each.value, "allowed_methods", [])
    allowed_origins = lookup(each.value, "allowed_origins", [])
    expose_headers  = lookup(each.value, "expose_headers", [])
  }
}

resource "aws_s3_bucket_logging" "this" {
  for_each = local.logging
  bucket   = aws_s3_bucket.this.id

  target_bucket = each.value["bucket"]
  target_prefix = each.value["prefix"]
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = local.acl
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = local.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = local.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  // checkov:skip=CKV_AWS_53: User defined input
  // checkov:skip=CKV_AWS_54: User defined input
  // checkov:skip=CKV_AWS_55: User defined input
  // checkov:skip=CKV_AWS_56: User defined input
  bucket                  = aws_s3_bucket.this.id
  block_public_policy     = local.public_access_block["block_public_policy"]
  block_public_acls       = local.public_access_block["block_public_acls"]
  restrict_public_buckets = local.public_access_block["restrict_public_buckets"]
  ignore_public_acls      = local.public_access_block["ignore_public_acls"]
}

data "aws_iam_policy_document" "this_ro" {
  count = local.suppress_iam ? 0 : 1
  statement {
    sid = "S3ListBucket"
    actions = [
      "s3:GetObject*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    dynamic "condition" {
      for_each = local.RO_policy_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

data "aws_iam_policy_document" "this_rw" {
  count = local.suppress_iam ? 0 : 1

  statement {
    sid = "S3ListBucket"
    actions = [
      "s3:*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    dynamic "condition" {
      for_each = local.RW_policy_conditions

      content {
        test     = condition.value.test
        variable = condition.value.variable
        values   = condition.value.values
      }
    }
  }
}

resource "aws_iam_policy" "this_rw" {
  count = local.suppress_iam ? 0 : 1

  name   = "${aws_s3_bucket.this.id}-rw"
  policy = data.aws_iam_policy_document.this_rw[0].json
}

resource "aws_iam_policy" "this_ro" {
  count = local.suppress_iam ? 0 : 1

  name   = "${aws_s3_bucket.this.id}-ro"
  policy = data.aws_iam_policy_document.this_ro[0].json
}

resource "aws_iam_group_policy_attachment" "this" {
  count = local.suppress_iam ? 0 : length(local.groups)

  group      = local.groups[count.index].name
  policy_arn = local.groups[count.index].mode == "RW" ? aws_iam_policy.this_rw[0].arn : aws_iam_policy.this_ro[0].arn
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.suppress_iam ? 0 : length(local.roles)

  role       = local.roles[count.index].name
  policy_arn = local.roles[count.index].mode == "RW" ? aws_iam_policy.this_rw[0].arn : aws_iam_policy.this_ro[0].arn
}
