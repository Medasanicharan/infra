## ---------------------------------------------------------------------------
## project / global
## ---------------------------------------------------------------------------

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "hotel-bookings"
}

variable "environment" {
  type = string
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "environment must be either \"dev\" or \"prod\"."
  }
}

variable "common_tags" {
  type = map(any)
  default = {
    Project   = "hotel-bookings"
    Terraform = "true"
  }
}

## ---------------------------------------------------------------------------
## networking (terraform-aws-vpc)
## ---------------------------------------------------------------------------

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "database_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

## ---------------------------------------------------------------------------
## security groups (terraform-aws-sg-module, instantiated 3x)
## ---------------------------------------------------------------------------

variable "sg_names" {
  default = ["alb", "ecs", "rds"]
}

variable "sg_descriptions" {
  default = [
    "sg for ALB - accepts HTTP/HTTPS from the internet",
    "sg for ECS/Fargate tasks - accepts app traffic from ALB only",
    "sg for RDS - accepts DB traffic from ECS only",
  ]
}

variable "container_port" {
  type    = number
  default = 8080
}

## ---------------------------------------------------------------------------
## alb / container (terraform-aws-alb-module, terraform-aws-ecs-module)
## ---------------------------------------------------------------------------

variable "certificate_arn" {
  description = "ACM certificate ARN. Leave empty for HTTP-only (dev)."
  type        = string
  default     = ""
}

variable "container_image" {
  type    = string
  default = "public.ecr.aws/nginx/nginx:1.27"
}

variable "task_cpu" {
  type    = number
  default = 256
}

variable "task_memory" {
  type    = number
  default = 512
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "min_capacity" {
  type    = number
  default = 1
}

variable "max_capacity" {
  type    = number
  default = 2
}

## ---------------------------------------------------------------------------
## rds (terraform-aws-rds-module)
## ---------------------------------------------------------------------------

variable "db_engine" {
  type    = string
  default = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.db_engine)
    error_message = "db_engine must be \"postgres\" or \"mysql\"."
  }
}

variable "db_engine_version" {
  type    = string
  default = "16.4"
}

variable "db_name" {
  type    = string
  default = "bookings"
}

variable "master_username" {
  type    = string
  default = "app_admin"
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "multi_az" {
  type = bool
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "monitoring_interval" {
  type    = number
  default = 0
}

variable "alarm_sns_topic_arn" {
  type    = string
  default = null
}
