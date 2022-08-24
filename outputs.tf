output "bucket" {
  description = "The s3 output object containing select values of the bucket."
  value = {
    id  = aws_s3_bucket.this.id
    arn = aws_s3_bucket.this.arn
  }
}

output "policies" {
  description = "Policies"

  value = {
    rw = one(aws_iam_policy.this_rw),
    ro = one(aws_iam_policy.this_ro),
  }
}

output "kms_arn" {
  description = "ARN of the kms key created"

  value = try(
    data.aws_kms_key.this.0.arn,
    null
  )
}
