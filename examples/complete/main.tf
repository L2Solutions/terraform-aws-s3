resource "aws_iam_role" "example" {
  name_prefix = "example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


module "example" {
  // checkov:skip=CKV_AWS_18: Ignore logging in example
  // checkov:slip=CKV_AWS_144: Ignore cross-region in example

  source = "../.."

  name          = "example"
  name_override = true
  use_prefix    = false

  roles = [{
    name = aws_iam_role.example.name
    mode = "RO"
  }]

  cors_rule = {
    rule1 = {
      allowed_headers = []
      allowed_methods = ["GET"]
      allowed_origins = ["*"]
      expose_headers  = []
    }
  }

  public_access_block = {
    block_public_policy     = true
    block_public_acls       = true
    restrict_public_buckets = true
    ignore_public_acls      = true
  }
}
