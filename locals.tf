## db_port is computed once, here, from var.db_engine, and fed to both the
## SG rule (ECS -> RDS) below and the rds module itself. This removes the
## drift risk where the SG rule's hardcoded port and the RDS engine's actual
## port were two independent values that could silently fall out of sync if
## the engine was ever switched.
         
locals {
  db_port = var.db_engine == "postgres" ? 5432 : 3306
}
