# -----------------------------------------------------------------
# remove temporary terraform files
# -----------------------------------------------------------------
.PHONY: clean
clean: ## remove .terraform
	find . -name ".terra*" -exec rm -rf {} \;

# -----------------------------------------------------------------
# destroy
# -----------------------------------------------------------------
.PHONY: destroy
destroy: ## destroy platform
	kind delete cluster --name sicily && find . -name ".terra*" -exec rm -rf {} \;

# -----------------------------------------------------------------
# provision-cluster
# -----------------------------------------------------------------
.PHONY: provision-cluster
provision-cluster: ## destroy platform
	kind create cluster --config=kind-cluster/kind-config-sicily.yaml --kubeconfig=$(HOME)/.kube/config --image kindest/node:v1.27.2 --wait 5m

# -----------------------------------------------------------------
# bootstrap cluster
# -----------------------------------------------------------------
.PHONY: bootstrap
bootstrap: ## create namespace for terraform state
	kubectl create ns terragrunt-state-dev


# -----------------------------------------------------------------
# plan platform
# -----------------------------------------------------------------
.PHONY: plan
plan: ## get plan from terragrunt
	terragrunt run-all plan --terragrunt-working-dir non-prod/environments/dev/sicily

# -----------------------------------------------------------------
# deploy platform
# -----------------------------------------------------------------
.PHONY: deploy
deploy: ## apply terragrunt
	terragrunt run-all apply --terragrunt-working-dir non-prod/environments/dev/sicily
