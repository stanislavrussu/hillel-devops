provider "aws" {
  # profile = var.profile
  # region  = var.region
  region = "us-east-1"
}

data "terraform_remote_state" "certificate" {
  backend = "remote"

  config = {
    organization = "hillel-practice-project"
    workspaces = {
      name = "assets"
    }
    token = var.remote_state_token
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
  vpc_cidr = data.aws_ssm_parameter.vpc_cidr.value
  tags     = jsondecode(replace(data.aws_ssm_parameter.tags.value, "=", ":"))
}

module "frontend" {
  source = "./modules/frontend"
  # arn         = module.certificate.acm_certificate_arn
  arn            = data.terraform_remote_state.certificate.outputs.acm_certificate_arn
  s3_bucket_name = data.aws_ssm_parameter.s3_bucket_name.value
  domain_name    = data.aws_ssm_parameter.domain_name.value
  # depends_on  = [module.certificate]
}

module "ecs_cluster" {
  source          = "./modules/ecs_cluster"
  cluster_name    = replace(data.aws_ssm_parameter.domain_name.value, ".", "-") #just fooling around with functions ^_^
  tags            = jsondecode(replace(data.aws_ssm_parameter.tags.value, "=", ":"))
  instance_type   = data.aws_ssm_parameter.instance_type.value
  ec2_sg_list     = module.vpc.ec2_sg_list
  subnets_id_list = module.vpc.subnets_id_list
  public_key      = data.aws_ssm_parameter.public_key.value
}

module "lb" {
  source = "./modules/lb"
  # acm_certificate_arn = module.certificate.acm_certificate_arn
  acm_certificate_arn = data.terraform_remote_state.certificate.outputs.acm_certificate_arn
  lb_name             = replace(data.aws_ssm_parameter.domain_name.value, ".", "-")
  alb_sg_list         = module.vpc.alb_sg_list
  subnets_id_list     = module.vpc.subnets_id_list
  domain_name         = data.aws_ssm_parameter.domain_name.value
  tags                = jsondecode(replace(data.aws_ssm_parameter.tags.value, "=", ":"))
}

module "ecs_service" {
  source           = "./modules/ecs_service"
  service_name     = data.aws_ssm_parameter.service_name.value
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_name
  ecs_cluster_arn  = module.ecs_cluster.ecs_cluster_arn
  alb_listener_arn = module.lb.alb_listener_arn
  vpc_id           = module.vpc.vpc_id
  # tags           = var.tags
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

# output "grand_finale_1" {
#  value = list(values({
#   s3_bucket_name     = module.frontend.aws_s3_bucket
#   aws_ecr_repository = module.ecs_service.aws_ecr_repository
#  }))
# }

# output "grand_finale_2" {
#  value = ["s3_bucket_name ↓ ", module.frontend.aws_s3_bucket, "aws_ecr_repository ↓ ", module.ecs_service.aws_ecr_repository]
# }

output "grand_finale_3" {
  value = {
    "s3_bucket_name"     = module.frontend.aws_s3_bucket
    "aws_ecr_repository" = module.ecs_service.aws_ecr_repository
  }
}
