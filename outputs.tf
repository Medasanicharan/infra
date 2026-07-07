## ---------------------------------------------------------------------------
## networking
## ---------------------------------------------------------------------------

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "azs" {
  value = module.vpc.azs
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
  value = module.vpc.database_subnet_ids
}

output "igw_id" {
  value = module.vpc.igw_id
}

## ---------------------------------------------------------------------------
## security groups
## ---------------------------------------------------------------------------

output "alb_sg_id" {
  value = module.sg[0].sg_id
}

output "ecs_sg_id" {
  value = module.sg[1].sg_id
}

output "rds_sg_id" {
  value = module.sg[2].sg_id
}

## ---------------------------------------------------------------------------
## alb — used directly for end-to-end verification (curl this)
## ---------------------------------------------------------------------------

output "alb_dns_name" {
  description = "Public entry point. curl this to test the Internet -> ALB -> ECS path."
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  value = module.alb.alb_arn
}

output "target_group_arn" {
  description = "Use with: aws elbv2 describe-target-health --target-group-arn <this>"
  value       = module.alb.target_group_arn
}

## ---------------------------------------------------------------------------
## ecs
## ---------------------------------------------------------------------------

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

## ---------------------------------------------------------------------------
## rds
## ---------------------------------------------------------------------------

output "db_endpoint" {
  value     = module.rds.db_endpoint
  sensitive = true
}

output "db_address" {
  description = "RDS host only, no port. Used as DB_HOST in the ECS task."
  value       = module.rds.db_address
}

output "db_port" {
  value = module.rds.db_port
}

output "db_instance_id" {
  value = module.rds.db_instance_id
}

output "db_master_user_secret_arn" {
  description = "Fetch credentials with: aws secretsmanager get-secret-value --secret-id <this arn>"
  value       = module.rds.secret_arn
}
