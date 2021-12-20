locals {
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  account_vars      = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  env               = local.environment_vars.locals.environment
  tenant            = local.environment_vars.locals.tenant
  aws_account_stage = local.account_vars.locals.aws_account_stage
  aws_account_id    = local.account_vars.locals.aws_account_id
}

terraform {
  source = "../../../../..//modules/security"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  environment       = local.env
  aws_account_stage = local.aws_account_stage
  tenant            = local.tenant
  aws_account_id    = local.aws_account_id
}
