terraform_version_constraint = "~> 1.0"

locals {
  # Automatically load global variables
  global_vars = read_terragrunt_config(find_in_parent_folders("global.hcl"))

  # Automatically load environment variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Load cluster variables
  cluster_vars = read_terragrunt_config(find_in_parent_folders("cluster.hcl"))

  # Extract the variables we need for easy access
  kube_config_path = local.global_vars.locals.kube_config_path

  environment = local.environment_vars.locals.environment

  cluster_name        = local.cluster_vars.locals.cluster_name
  kube_config_context = local.cluster_vars.locals.kube_config_context
}

# Automatically set providers region everywhere
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite" #overwrite existing file in case provider.tf exists
  contents  = <<-EOF
    provider "kubernetes" {
      config_path   = "${local.kube_config_path}"
      config_context = "${local.kube_config_context}"
    }

    provider "helm" {
      kubernetes {
        config_path = "${local.kube_config_path}"
        config_context = "${local.kube_config_context}"
      }
    }

    provider "argocd" {
      server_addr = "localhost:8080" //TODO change after local DNS is implemented
      username    = "admin"
      password    = "dev"
      insecure    = "true"
    }

    provider "htpasswd" {
    }

    provider "random" {
    }

  EOF
}

generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite" #overwrite existing file in case provider.tf exists
  contents  = <<EOF
    terraform {
      required_providers {
        kubernetes   = {
          source  = "hashicorp/kubernetes"
          version = "~> 2.6, < 2.14"
        }
        helm = {
          source  = "hashicorp/helm"
          version = "~> 2.7"
        }
        argocd = {
          source  = "oboukili/argocd"
          version = "~> 3.2.0"
        }
        htpasswd = {
          source = "loafoe/htpasswd"
          version = "1.0.4"
        }
        random = {
          source = "hashicorp/random"
          version = "3.4.3"
        }
        grafana = {
          source = "grafana/grafana"
          version = "~> 1.31.1"
        }
      }
    }

EOF
}

remote_state {
  backend = "kubernetes"

  config = {
    secret_suffix  = "${replace(path_relative_to_include(), "/", "-")}"
    config_path    = "${local.kube_config_path}"
    config_context = "${local.kube_config_context}"
    namespace      = "terragrunt-state-${local.environment}"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}