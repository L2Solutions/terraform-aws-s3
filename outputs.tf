output "s3_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of created S3 bucket"
}

output "rw_arn" {
  value       = local.suppress_iam ? null : aws_iam_policy.this_rw[0].arn
  description = "Read/Write S3 policy ARN"
}

output "ro_arn" {
  value       = local.suppress_iam ? null : aws_iam_policy.this_ro[0].arn
  description = "Read Only S3 policy ARN"
}

output "s3_id" {
  value       = aws_s3_bucket.this.id
  description = "ID of created S3 bucket"
}
