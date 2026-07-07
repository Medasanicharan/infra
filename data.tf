## ---------------------------------------------------------------------------
## Account / region context — NOT required by this assignment
## ---------------------------------------------------------------------------
## The assessment only requires `terraform fmt / init / validate / plan`
## (plan-only, no real AWS deployment). These data sources aren't consumed
## by anything in Part 1–2 of the task, so they're commented out to avoid
## unused-data-source noise in `terraform validate`.
##
## If this stack is ever actually applied to a real AWS account, uncomment
## this block — `parameter.tf` depends on `data.aws_caller_identity.current`
## and `data.aws_region.current` to publish account ID / region to SSM.


/* data "aws_caller_identity" "current" {}

data "aws_region" "current" {} */

