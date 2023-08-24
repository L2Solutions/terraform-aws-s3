# Terraform AWS S3 Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_group_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.this_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.this_rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this_aes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_policy_document.this_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this_rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | Canned ACL grant | `string` | `null` | no |
| <a name="input_config_cors"></a> [config\_cors](#input\_config\_cors) | CORS Configuration | <pre>object({<br>    rules = optional(list(object({<br>      allowed_headers = optional(list(string))<br>      allowed_methods = optional(list(string))<br>      allowed_origins = optional(list(string))<br>      expose_headers  = optional(list(string))<br>    })), [])<br>  })</pre> | `{}` | no |
| <a name="input_config_iam"></a> [config\_iam](#input\_config\_iam) | Bucket IAM Configuration | <pre>object({<br>    enable        = optional(bool, true),<br>    bucket_policy = optional(string, "")<br>    policy_conditions = optional(map(list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    }))), {})<br>  })</pre> | <pre>{<br>  "enable": true<br>}</pre> | no |
| <a name="input_config_logging"></a> [config\_logging](#input\_config\_logging) | Logging Configuration - List of objects with target bucket and key prefix(defaults to bucket resource ID) | <pre>object({<br>    enable = optional(bool),<br>    buckets = optional(map(object({<br>      target_bucket = string<br>      target_prefix = optional(string)<br>    })), {})<br>  })</pre> | `{}` | no |
| <a name="input_enable_versioning"></a> [enable\_versioning](#input\_enable\_versioning) | Use bucket versioning | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Force Destroy S3 Bucket | `bool` | `false` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | Group names to attach | <pre>map(object({<br>    name = string<br>    mode = optional(string, "ro")<br>  }))</pre> | `{}` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Instance of labels module | <pre>object(<br>    {<br>      id   = string<br>      tags = any<br>    }<br>  )</pre> | <pre>{<br>  "id": "",<br>  "tags": {}<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the s3 bucket | `string` | n/a | yes |
| <a name="input_name_override"></a> [name\_override](#input\_name\_override) | Name override the opinionated name variable | `bool` | `false` | no |
| <a name="input_public_access_block"></a> [public\_access\_block](#input\_public\_access\_block) | Public Access Block Configuration | <pre>object({<br>    block_public_policy     = optional(bool, true)<br>    block_public_acls       = optional(bool, true)<br>    restrict_public_buckets = optional(bool, true)<br>    ignore_public_acls      = optional(bool, true)<br>  })</pre> | `{}` | no |
| <a name="input_roles"></a> [roles](#input\_roles) | Roles to attach | <pre>map(object({<br>    name = string<br>    mode = optional(string, "ro")<br>  }))</pre> | `{}` | no |
| <a name="input_server_side_encryption_configuration"></a> [server\_side\_encryption\_configuration](#input\_server\_side\_encryption\_configuration) | Pass through to server\_side\_encryption\_configuration. If null is passed for kms\_master\_key\_id, will autocreate.<br>  An alias can also be passed to be created on the key. | <pre>object({<br>    type              = string<br>    kms_master_key_id = optional(string)<br>    alias             = optional(string)<br>  })</pre> | <pre>{<br>  "alias": null,<br>  "kms_master_key_id": null,<br>  "type": "aws:kms"<br>}</pre> | no |
| <a name="input_use_prefix"></a> [use\_prefix](#input\_use\_prefix) | Use var.name as name prefix instead | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket"></a> [bucket](#output\_bucket) | The s3 output object containing select values of the bucket. |
| <a name="output_kms_arn"></a> [kms\_arn](#output\_kms\_arn) | ARN of the kms key created |
| <a name="output_policies"></a> [policies](#output\_policies) | Policies |
| <a name="output_policy_documents"></a> [policy\_documents](#output\_policy\_documents) | Policy documents |
<!-- END_TF_DOCS -->
