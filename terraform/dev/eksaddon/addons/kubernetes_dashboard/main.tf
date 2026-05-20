locals {
  dashboard_vars = {
  }
  helm_values = templatefile(
    "${path.module}/helm-values.tmpl",
    local.dashboard_vars
  )
}

resource "helm_release" "this" {
  name             = var.name
  repository       = "https://kubernetes.github.io/dashboard"
  chart            = "kubernetes-dashboard"
  namespace        = var.namespace
  create_namespace = true
  version          = var.helmversion
  values           = [local.helm_values]
}

locals {
  addon_vars = {
    namespace       = var.namespace
    alb_name        = var.alb_name
    certificate_arn = var.certificate_arn
    alb_type        = var.external == true ? "internet-facing" : "internal"
    url             = var.url
  }
}

data "kubectl_file_documents" "this" {
  content = templatefile(
    "${path.module}/dashboard-addon.tmpl",
  local.addon_vars)
}

locals {
  yaml_dashboard_addon = split("---", data.kubectl_file_documents.this.content)
}

resource "kubectl_manifest" "this" {
  depends_on = [helm_release.this]
  count      = length(local.yaml_dashboard_addon)
  yaml_body  = local.yaml_dashboard_addon[count.index]
}

data "kubectl_file_documents" "metrics" {
  content = templatefile(
    "${path.module}/components.yaml", {}
  )
}

locals {
  yaml_metrics = split("---", data.kubectl_file_documents.metrics.content)
}

resource "kubectl_manifest" "metrics_server" {
  count     = length(local.yaml_metrics)
  yaml_body = local.yaml_metrics[count.index]
}
