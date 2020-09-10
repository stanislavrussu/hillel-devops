provider "aws" {
  region = var.region
}

module "certificate" {
  source      = "./modules/certificate"
  domain_name = var.domain_name
}