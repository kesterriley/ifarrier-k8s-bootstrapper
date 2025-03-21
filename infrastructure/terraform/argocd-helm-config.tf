resource "helm_release" "argocd" {
  count            = var.enable_argocd_helm_release ? 1 : 0
  name             = var.argocd_helm_release_name
  namespace        = var.argocd_k8s_namespace
  repository       = var.argocd_helm_repo
  chart            = var.argocd_helm_chart
  version          = var.argocd_helm_chart_version
  timeout          = var.argocd_helm_chart_timeout_seconds
  create_namespace = true

  # Additional Helm values
  # Enable if you want to install high-availability argocd
  # values = [
  #   file(var.argocd_additional_helm_values_file)
  # ]

  depends_on = [
    helm_release.sealed-secrets
  ]
}

resource "helm_release" "argocd-apps" {
  depends_on = [helm_release.argocd]
  chart      = "argocd-apps"
  name       = "argocd-apps"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"

  # (6)
  values = [
    file("../../bootstrap/bootstrap.yaml")
  ]
}