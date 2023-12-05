terraform {
  source = "git::git@github.com:s28938/terraform-modules.git//app-of-apps?ref=tf-lab"
}

dependencies {
  paths = ["${get_terragrunt_dir()}/../argocd"]
}

locals {
  # Load environment variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  namespace = local.env_vars.locals.namespace
}

inputs = {
  application_namespace = local.namespace
  destination_namespace = local.namespace
  argocd_project        = "default"
  app_of_apps           = {
    repo_url        = "https://github.com/s28938/test-deployment.git"
    path            = "apps"
    target_revision = "main"
  }
}
