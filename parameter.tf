## ---------------------------------------------------------------------------
## SSM Parameter Store 
## ---------------------------------------------------------------------------
## Publishes the values other stacks/layers most commonly need to consume
## (e.g. a future "app" or "monitoring" layer) under a predictable path:
##   /<project_name>/<environment>/<name>
##
## Left commented out because the assignment is plan-only (no real AWS
## deployment) and doesn't ask for cross-stack parameter sharing. Kept here
## to show how this stack would expose its outputs to other stacks in a
## real environment. Uncomment to activate once this is actually applied
## against an AWS account — requires the data sources in data.tf as well.


## networking

/* resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnet_ids)
}

## security groups

resource "aws_ssm_parameter" "alb_sg_id" {
  name  = "/${var.project_name}/${var.environment}/alb_sg_id"
  type  = "String"
  value = module.sg[0].sg_id
}

resource "aws_ssm_parameter" "ecs_sg_id" {
  name  = "/${var.project_name}/${var.environment}/ecs_sg_id"
  type  = "String"
  value = module.sg[1].sg_id
}

resource "aws_ssm_parameter" "rds_sg_id" {
  name  = "/${var.project_name}/${var.environment}/rds_sg_id"
  type  = "String"
  value = module.sg[2].sg_id
}

## alb

resource "aws_ssm_parameter" "alb_dns_name" {
  name  = "/${var.project_name}/${var.environment}/alb_dns_name"
  type  = "String"
  value = module.alb.alb_dns_name
}

resource "aws_ssm_parameter" "alb_arn" {
  name  = "/${var.project_name}/${var.environment}/alb_arn"
  type  = "String"
  value = module.alb.alb_arn
}

resource "aws_ssm_parameter" "target_group_arn" {
  name  = "/${var.project_name}/${var.environment}/target_group_arn"
  type  = "String"
  value = module.alb.target_group_arn
}

## ecs

resource "aws_ssm_parameter" "ecs_cluster_name" {
  name  = "/${var.project_name}/${var.environment}/ecs_cluster_name"
  type  = "String"
  value = module.ecs.cluster_name
}

resource "aws_ssm_parameter" "ecs_service_name" {
  name  = "/${var.project_name}/${var.environment}/ecs_service_name"
  type  = "String"
  value = module.ecs.service_name
}

## rds
## NOTE: db_address/db_port are intentionally published as plain (non-secret)
## String parameters - RDS is only reachable from the ECS security group, so
## host/port alone carry no risk. Credentials stay exclusively in the
## AWS-managed Secrets Manager secret referenced by db_master_user_secret_arn.

resource "aws_ssm_parameter" "db_address" {
  name  = "/${var.project_name}/${var.environment}/db_address"
  type  = "String"
  value = module.rds.db_address
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.project_name}/${var.environment}/db_port"
  type  = "String"
  value = tostring(module.rds.db_port)
}

resource "aws_ssm_parameter" "db_instance_id" {
  name  = "/${var.project_name}/${var.environment}/db_instance_id"
  type  = "String"
  value = module.rds.db_instance_id
}

resource "aws_ssm_parameter" "db_master_user_secret_arn" {
  name  = "/${var.project_name}/${var.environment}/db_master_user_secret_arn"
  type  = "String"
  value = module.rds.secret_arn
}

## account / region context (from data.tf)

resource "aws_ssm_parameter" "account_id" {
  name  = "/${var.project_name}/${var.environment}/account_id"
  type  = "String"
  value = data.aws_caller_identity.current.account_id
}

resource "aws_ssm_parameter" "aws_region" {
  name  = "/${var.project_name}/${var.environment}/aws_region"
  type  = "String"
  value = data.aws_region.current.name
}
 */