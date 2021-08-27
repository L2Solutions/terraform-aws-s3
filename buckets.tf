
resource "aws_s3_bucket" "this" {
  bucket        = local.use_prefix ? null : local.bucket_name
  bucket_prefix = local.use_prefix ? local.bucket_name : null
  acl           = local.acl

  versioning {
    enabled = local.versioning
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = local.sse_algorithm
      }
    }
  }

  dynamic "cors_rule" {
    for_each = local.cors_rule

    content {
      allowed_headers = lookup(cors_rule.value, "allowed_headers", [])
      allowed_methods = lookup(cors_rule.value, "allowed_methods", [])
      allowed_origins = lookup(cors_rule.value, "allowed_origins", [])
      expose_headers  = lookup(cors_rule.value, "expose_headers", [])
    }
  }

  dynamic "logging" {
    for_each = local.logging

    content {
      target_bucket = logging.value["bucket"]
      target_prefix = logging.value["prefix"]
    }
  }
}

data "aws_iam_policy_document" "this_ro" {
  count = local.supress_iam ? 0 : 1
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
  }
}

data "aws_iam_policy_document" "this_rw" {
  count = local.supress_iam ? 0 : 1

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
  }
}

resource "aws_iam_policy" "this_rw" {
  count = local.supress_iam ? 0 : 1

  name_prefix = "${local.bucket}-rw"
  policy      = data.aws_iam_policy_document.this_rw[0].json
}

resource "aws_iam_policy" "this_ro" {
  count = local.supress_iam ? 0 : 1


  name_prefix = "${local.bucket}-ro"
  policy      = data.aws_iam_policy_document.this_ro[0].json
}

resource "aws_iam_group_policy_attachment" "this" {
  count = local.supress_iam ? 0 : length(local.groups)

  group      = local.groups[count.index].name
  policy_arn = local.groups[count.index].mode == "RW" ? aws_iam_policy.this_rw[0].arn : aws_iam_policy.this_ro[0].arn
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.supress_iam ? 0 : length(local.roles)

  role       = local.roles[count.index].name
  policy_arn = local.roles[count.index].mode == "RW" ? aws_iam_policy.this_rw[0].arn : aws_iam_policy.this_ro[0].arn
}