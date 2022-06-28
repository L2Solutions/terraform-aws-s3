provider "aws" {
  region = "us-east-2"
}

module "labels" {
  source  = "skyfjell/label/null"
  version = "1.0.1"

  tenant      = "tf"
  environment = "test"
  project     = "mods"
  name        = "aws"
  app         = "s3"
}


module "simple" {
  source = "../.."

  name   = "simple"
  labels = module.labels
}

output "bucket" {
  value = module.simple.s3_id
}
