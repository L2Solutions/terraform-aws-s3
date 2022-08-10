module "labels" {
  source = "skyfjall/label/null"

  tenant      = "tf"
  environment = "test"
  project     = "mods"
  name        = "aws"
  app         = "s3"
}

resource "aws_iam_role" "this" {
  name_prefix = join("-", [module.labels.id])
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

  tags = module.labels.tags
}


module "logs" {
  source = "../.."

  name       = "access-logs"
  use_prefix = true
  labels     = module.labels
  server_side_encryption_configuration = {
    type = "AES256"
  }

  config_logging = {
    enable = false
  }
}

module "this" {
  source = "../.."

  name       = "basic"
  use_prefix = true
  labels     = module.labels

  roles = {
    s3policy-ro = {
      name = aws_iam_role.this.name
      mode = "ro"
    }
  }

  server_side_encryption_configuration = {
    type = "AES256"
  }

  config_logging = {
    access_logs = {
      target_bucket = module.logs.bucket.id
    }
  }

  config_iam = {
    policy_conditions = {
      ro = [
        {
          test     = "StringLike"
          values   = ["home/", "other/"]
          variable = "s3:prefix"
        },
        {
          test     = "StringEquals"
          values   = ["test"]
          variable = "s3:prefix"
        }
      ],
      rw = [
        {
          test     = "StringLike"
          values   = ["home/"]
          variable = "s3:prefix"
        }
      ]
    }
  }


}


output "bucket" {
  value = module.this.bucket.id
}

output "policy_json" {
  value = module.this.policies.ro
}
