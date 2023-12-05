locals {
  environment = "dev"
  namespace   = "pjatk-${local.environment}"
  components  = {
    ingress-nginx = {
      chart_version = "9.3.18"
    }
    cert-manager = {
      chart_version = "0.4.17"
    }
    argocd = {
      chart_version = "5.50.1"
    }
    kube-prometheus-stack = {
      chart_version = "41.7.2"
    }
    logging-operator = {
      chart_version = "3.17.9"
    }
    loki = {
      chart_version = "3.3.4"
    }
    logging = {
      chart_version = "3.17.8"
    }
    crossplane = {
      chart_version = "1.10.2"
    }
  }
}
