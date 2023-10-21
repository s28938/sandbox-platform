include "root" {
  path   = find_in_parent_folders()
}

# Include the envcommon configuration for the component. The envcommon configuration contains settings that are common
# for the component across all environments.
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/argocd.hcl"
}

inputs = {
  admin_password = "dev" //TODO inject from some secret store
}