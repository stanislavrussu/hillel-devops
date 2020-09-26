data "aws_ssm_parameter" "vpc_cidr" {
  name = "/${var.GIT_BRANCH}/VPC_CIDR"
}

data "aws_ssm_parameter" "tags" {
  name = "/${var.GIT_BRANCH}/TAGS"
}

data "aws_ssm_parameter" "domain_name" {
  name = "/${var.GIT_BRANCH}/DOMAIN_NAME"
}

data "aws_ssm_parameter" "s3_bucket_name" {
  name = "/${var.GIT_BRANCH}/FE_S3_Bucket"
}

data "aws_ssm_parameter" "instance_type" {
  name = "/${var.GIT_BRANCH}/INSTANCE_TYPE"
}

data "aws_ssm_parameter" "public_key" {
  name = "/${var.GIT_BRANCH}/PUBLIC_KEY"
}

data "aws_ssm_parameter" "service_name" {
  name = "/${var.GIT_BRANCH}/ECS_SERVICE_NAME"
}
