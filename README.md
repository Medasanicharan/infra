# hotel-bookings-infra-v2

Terraform root module that provisions the full Hotel Bookings AWS
environment: VPC, security groups, ALB, ECS/Fargate service, and RDS
(Postgres). One `terraform apply` per environment (`dev`, `prod`) builds the
entire stack.

## Architecture

```
Internet
   │
   ▼
 ALB (public subnets)  ──┐
   │                     │  aws_security_group_rule (chained by SG, not CIDR)
   ▼                     │
 ECS/Fargate (private subnets)
   │
   ▼
 RDS Postgres (database subnets, private, no public access)
```

- **Networking**: 3-tier VPC (public / private / database subnets) across 2
  AZs, NAT gateway(s), and a database subnet group.
- **Security groups**: one SG per tier (`alb`, `ecs`, `rds`). Traffic is only
  ever allowed from the security group in front of it in the chain — never
  by CIDR — past the ALB.
- **ALB**: HTTP listener always present; HTTPS listener/redirect created
  automatically the moment `certificate_arn` is set.
- **ECS**: Fargate service + task definition, autoscaling on CPU, execution
  role scoped to exactly one Secrets Manager secret, CloudWatch alarm on
  high CPU.
- **RDS**: Postgres with `manage_master_user_password = true` — AWS
  generates, stores, and rotates the master password in Secrets Manager.
  No credential of any kind ever touches Terraform state or a `.tf` file.

## Repository layout

```
infra2/
├── main.tf          # wires all 5 modules together (sourced from GitHub)
├── variables.tf      # every input, with sane dev-friendly defaults
├── outputs.tf         # values needed to verify/operate the stack
├── data.tf            # account/region context (used for tagging + SSM paths)
├── parameter.tf        # publishes key outputs to SSM Parameter Store
├── provider.tf          # provider + partial S3 backend config
├── envs/
│   ├── dev/
│   │   ├── backend.tf   # -backend-config for dev state
│   │   └── dev.tfvars    # -var-file for dev
│   └── prod/
│       ├── backend.tf
│       └── prod.tfvars
└── .gitignore
```

The 5 child modules (`terraform-aws-vpc`, `terraform-aws-sg-module`,
`terraform-aws-alb-module`, `terraform-aws-ecs-module`,
`terraform-aws-rds-module`) are **not** stored in this repo. Each one lives
in its own GitHub repository and is pulled in by `main.tf` via a `git::`
source URL, e.g.:

```hcl
module "vpc" {
  source = "git::https://github.com/<YOUR_GITHUB_ORG>/terraform-aws-vpc.git?ref=main"
  ...
}
```

Before first use, replace `<YOUR_GITHUB_ORG>` in `main.tf` with your actual
GitHub org/user for all 5 modules, and push each folder under
`github-modules/` (from the delivered zip) to its own repository of the
same name. Once each module repo is tagged (e.g. `v1.0.0`), pin
`?ref=main` to that tag instead of tracking a moving branch.

## SSM Parameter Store outputs (`parameter.tf`)

Every important output is also published to SSM under:

```
/<project_name>/<environment>/<name>
```

e.g. `/hotel-bookings/dev/vpc_id`, `/hotel-bookings/dev/alb_dns_name`,
`/hotel-bookings/dev/db_master_user_secret_arn`. This lets other
stacks/layers (a future app layer, a CI/CD pipeline, a monitoring stack)
look values up with a plain `data "aws_ssm_parameter"` instead of reaching
into this stack's remote state.

## Usage

```bash
# dev
terraform init   -backend-config=envs/dev/backend.tf
terraform plan   -var-file=envs/dev/dev.tfvars
terraform apply  -var-file=envs/dev/dev.tfvars

# prod
terraform init   -reconfigure -backend-config=envs/prod/backend.tf
terraform plan   -var-file=envs/prod/prod.tfvars
terraform apply  -var-file=envs/prod/prod.tfvars
```

## Verifying the deployment

```bash
# ECS targets should be healthy
aws elbv2 describe-target-health \
  --target-group-arn $(terraform output -raw target_group_arn)

# Internet -> ALB -> ECS should return 200
curl -i http://$(terraform output -raw alb_dns_name)/

# RDS must NOT be reachable from outside the ECS security group
# (a timeout here is success)
timeout 5 bash -c "cat < /dev/null > /dev/tcp/$(terraform output -raw db_address)/$(terraform output -raw db_port)" \
  && echo "UNEXPECTED: reachable" || echo "timed out as expected — RDS is private"

# Fetch DB master credentials when needed
aws secretsmanager get-secret-value \
  --secret-id $(terraform output -raw db_master_user_secret_arn)
```

## Notes

- `container_image` defaults to a placeholder `nginx` image. Swap it for
  the real application image, and update the ECS task definition's
  `healthCheck` command from the `nc` placeholder to a real
  `curl -f http://localhost:PORT/health` once the real image is in place.
- `certificate_arn` is empty by default (HTTP-only). Supply a real ACM
  certificate ARN to get an HTTPS listener + automatic HTTP→HTTPS redirect.
- `alarm_sns_topic_arn` is `null` by default — CloudWatch alarms still
  exist and are visible in the console/CLI, they just have no notification
  action until a real SNS topic ARN is supplied.
