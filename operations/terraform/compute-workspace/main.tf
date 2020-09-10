provider "aws" {
  profile = var.profile
  region  = var.region
}

data "terraform_remote_state" "certificate" {
  backend = "remote"

  config = {
    organization = "hillel-practice-project"
    workspaces = {
      name = "assets"
    }
  }
}

# module "spa" {
#  count         = 1
#  source        = "./modules/spa"
#  ami_id        = var.ami_id
#  instance_type = var.instance_type
#  eip_attach    = false
# }

# module "certificate" {
# source      = "./modules/certificate"
# domain_name = var.domain_name
# }

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  tags     = var.tags
}

module "frontend" {
  source = "./modules/frontend"
  # arn         = module.certificate.acm_certificate_arn
  arn         = data.terraform_remote_state.certificate.outputs.acm_certificate_arn
  domain_name = var.domain_name
  # depends_on  = [module.certificate]
}

module "ecs_cluster" {
  source          = "./modules/ecs_cluster"
  cluster_name    = replace(var.domain_name, ".", "-") #just fooling around with functions ^_^
  tags            = var.tags
  instance_type   = var.instance_type
  ec2_sg_list     = module.vpc.ec2_sg_list
  subnets_id_list = module.vpc.subnets_id_list
  public_key      = var.public_key
}

module "lb" {
  source = "./modules/lb"
  # acm_certificate_arn = module.certificate.acm_certificate_arn
  acm_certificate_arn = data.terraform_remote_state.certificate.outputs.acm_certificate_arn
  lb_name             = replace(var.domain_name, ".", "-")
  alb_sg_list         = module.vpc.alb_sg_list
  subnets_id_list     = module.vpc.subnets_id_list
  domain_name         = var.domain_name
  tags                = var.tags
}

module "ecs_service" {
  source           = "./modules/ecs_service"
  service_name     = var.service_name
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  ecs_cluster_arn  = module.ecs_cluster.ecs_cluster_arn
  alb_listener_arn = module.lb.alb_listener_arn
  vpc_id           = module.vpc.vpc_id
  # tags             = var.tags
}

# output instance_pub_ips {
#  value     = module.spa[*].instance_pub_ip
#  sensitive = false
# }

# output "s3_bucket_name" {
#  value = module.frontend.aws_s3_bucket
# }
# output "aws_ecr_repository" {
#  value = module.ecs_service.aws_ecr_repository
# }

# output "main" {
#  value = list(values({
#   s3_bucket_name     = module.frontend.aws_s3_bucket
#   aws_ecr_repository = module.ecs_service.aws_ecr_repository
#  }))
# }

output "grand_finale" {
  value = "${concat(
    "s3_bucket_name - ", module.frontend.aws_s3_bucket, "\t\n", "aws_ecr_repository - ", module.ecs_service.aws_ecr_repository
  )}"
}