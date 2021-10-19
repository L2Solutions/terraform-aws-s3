# terraform-aws-s3

Utility module for creating a S3 bucket with ReadOnly and ReadWrite permissions as well as role and group attachments.

- [Registry](https://registry.terraform.io/modules/OmniTeqSource/s3/aws/latest)

## terraform-docs usage

`sed -i '' '/^<!--- start terraform-docs --->/q' README.md && terraform-docs md . >> README.md`

<!--- start terraform-docs --->

## Requirements

| Name                                                                     | Version            |
| ------------------------------------------------------------------------ | ------------------ |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.15            |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 3.48.0, < 4.0.0 |

## Providers

| Name                                             | Version            |
| ------------------------------------------------ | ------------------ |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 3.48.0, < 4.0.0 |

## Modules

No modules.

## Resources

| Name                                                                                                                                            | Type        |
| ----------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_iam_group_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource    |
| [aws_iam_policy.this_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                | resource    |
| [aws_iam_policy.this_rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)                                | resource    |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)   | resource    |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                     | resource    |
| [aws_iam_policy_document.this_ro](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)           | data source |
| [aws_iam_policy_document.this_rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document)           | data source |

## Inputs

| Name                                                                        | Description                                                    | Type                                                                 | Default     | Required |
| --------------------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------------- | ----------- | :------: |
| <a name="input_acl"></a> [acl](#input_acl)                                  | Bucket ACL                                                     | `string`                                                             | `"private"` |    no    |
| <a name="input_cors_rule"></a> [cors_rule](#input_cors_rule)                | value                                                          | `map(any)`                                                           | `null`      |    no    |
| <a name="input_groups"></a> [groups](#input_groups)                         | Group names to attach                                          | <pre>list(object({<br> name = string<br> mode = string<br> }))</pre> | `[]`        |    no    |
| <a name="input_labels"></a> [labels](#input_labels)                         | The labels module id                                           | <pre>object({<br> id = string<br> })</pre>                           | `null`      |    no    |
| <a name="input_logging"></a> [logging](#input_logging)                      | Pass null to disable logging or pass the logging bucket id     | `string`                                                             | n/a         |   yes    |
| <a name="input_logging_prefix"></a> [logging_prefix](#input_logging_prefix) | Will default to /{name}                                        | `string`                                                             | `null`      |    no    |
| <a name="input_name"></a> [name](#input_name)                               | The name of the s3 bucket                                      | `string`                                                             | n/a         |   yes    |
| <a name="input_name_override"></a> [name_override](#input_name_override)    | Name override the opinionated name variable                    | `bool`                                                               | `false`     |    no    |
| <a name="input_roles"></a> [roles](#input_roles)                            | Roles to attach                                                | <pre>list(object({<br> name = string<br> mode = string<br> }))</pre> | `[]`        |    no    |
| <a name="input_sse_algorithm"></a> [sse_algorithm](#input_sse_algorithm)    | The encryption algorithm                                       | `string`                                                             | `"AES256"`  |    no    |
| <a name="input_suppress_iam"></a> [suppress_iam](#input_suppress_iam)       | Supresses the module creating iam resources if none are needed | `bool`                                                               | `false`     |    no    |
| <a name="input_use_prefix"></a> [use_prefix](#input_use_prefix)             | Use var.name as name prefix instead                            | `bool`                                                               | `true`      |    no    |
| <a name="input_versioning"></a> [versioning](#input_versioning)             | Use bucket versioning                                          | `bool`                                                               | `true`      |    no    |

## Outputs

| Name                                                  | Description              |
| ----------------------------------------------------- | ------------------------ |
| <a name="output_ro_arn"></a> [ro_arn](#output_ro_arn) | Read Only S3 policy ARN  |
| <a name="output_rw_arn"></a> [rw_arn](#output_rw_arn) | Read/Write S3 policy ARN |
| <a name="output_s3_arn"></a> [s3_arn](#output_s3_arn) | ARN of created S3 bucket |
