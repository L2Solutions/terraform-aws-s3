
resource "aws_s3_bucket" "this" {
  bucket        = local.use_prefix ? null : local.bucket_name
  bucket_prefix = local.use_prefix ? local.bucket_name : null
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
  }
}

resource "aws_iam_policy" "this_rw" {
  count = local.suppress_iam ? 0 : 1

  name_prefix = "${local.bucket}-rw"
  policy      = data.aws_iam_policy_document.this_rw[0].json
}

resource "aws_iam_policy" "this_ro" {
  count = local.suppress_iam ? 0 : 1


  name_prefix = "${local.bucket}-ro"
  policy      = data.aws_iam_policy_document.this_ro[0].json
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
