terraform {
  source = "git::git@github.com:s28938/terraform-modules.git//kubernetes-namespace?ref=main"
}

locals {
  # Load environment variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Extract the variables we need for easy access
  namespace = local.environment_vars.locals.namespace
}

inputs = {
  namespace = local.namespace
}
