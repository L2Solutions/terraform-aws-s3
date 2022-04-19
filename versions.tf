terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }

  required_version = ">= 1.0.5"

  experiments = [module_variable_optional_attrs]
}
