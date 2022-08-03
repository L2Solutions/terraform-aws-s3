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
  server_side_encryption_configuration = {
    type = "AES256"
  }
}

output "bucket" {
  value = module.simple.s3.id
}
