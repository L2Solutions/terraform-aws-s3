terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.48.0, < 4.0.0"
    }
  }

  required_version = ">= 0.15"

  experiments = [module_variable_optional_attrs]
}
