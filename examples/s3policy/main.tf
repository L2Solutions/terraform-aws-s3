module "labels" {
  source = "skyfjall/label/null"

  tenant      = "tf"
  environment = "test"
  project     = "mods"
  name        = "aws"
  app         = "s3"
}

resource "aws_iam_role" "this" {
  name_prefix = "s3policy"
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


module "log" {
  source = "../.."

  name       = "log"
  use_prefix = true
  labels     = module.labels
  server_side_encryption_configuration = {
    type = "AES256"
  }
}

module "this" {
  source = "../.."

  name       = "s3policy"
  use_prefix = true
  labels     = module.labels

  roles = [{
    name = aws_iam_role.this.name
    mode = "RO"
  }]

  server_side_encryption_configuration = {
    type = "AES256"
  }

  logging = {
    target_bucket = module.log.s3_id
  }

  policy_conditions = {
    RO = {
      "key" = {
        test     = "StringLike"
        values   = ["home/", "other/"]
        variable = "s3:prefix"
      }
      "key2" = {
        test     = "StringEquals"
        values   = ["test"]
        variable = "s3:prefix"
      }
    }
    RW = {
      "key" = {
        test     = "StringLike"
        values   = ["home/"]
        variable = "s3:prefix"
      }
    }
  }
}


output "bucket" {
  value = module.this.s3_id
}

output "policy_json" {
  value = module.this.ro_policy
}
