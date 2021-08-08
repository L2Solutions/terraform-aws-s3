output "s3_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of created S3 bucket"
}

output "rw_arn" {
  value       = aws_iam_policy.this_ro.arn
  description = "Read/Write S3 policy ARN"
}

output "ro_arn" {
  value       = aws_iam_policy.this_ro
  description = "Read Only S3 policy ARN"
}