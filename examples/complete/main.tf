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
}
