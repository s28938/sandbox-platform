terraform {
  source = "git::git@github.com:s28938/terraform-modules.git//argocd?ref=main"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../platform-namespace"]
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  namespace     = local.env_vars.locals.namespace
  chart_version = local.env_vars.locals.components.argocd.chart_version
}

inputs = {
  namespace     = local.namespace
  chart_version = local.chart_version
}
