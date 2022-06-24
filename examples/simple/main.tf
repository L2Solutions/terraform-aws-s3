module "labels" {
  source = "skyfjall/label/null"

  tenant      = "tf"
  environment = "test"
  project     = "mods"
  name        = "aws"
  app         = "s3"
}


module "simple" {
  source = "../.."

  name       = "simple"
  use_prefix = true
  labels     = module.labels
}

output "bucket" {
  value = module.simple.s3_id
}
