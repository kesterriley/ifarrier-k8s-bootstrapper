# ===================== DO CONFIG VARS =======================
# do_token = "dop_v1..."
# ============================== DOKS CONFIG ==============================

doks_cluster_name_prefix = "k8s-ifarrier"
doks_k8s_version         = "1.32.1"
doks_cluster_region      = "lon1"

# Main pool configuration (REQUIRED)

doks_default_node_pool = {
  name       = "ifarrier-main"
  node_count = 1
  size       = "s-2vcpu-4gb"
  auto_scale = true
  min_nodes  = 1
  max_nodes  = 2
}

# Create additional DOKS node pools 
# Dedicated node pools are useful to spread the load 
# Created by each component, such as: observer (OPTIONAL)

# doks_additional_node_pools = {
#   "ifarrier-observer" = {
#     node_count = 1
#     size       = "s-2vcpu-4gb"
#   }
# }

# ======================= DIGITALOCEAN CONTAINER REGISTRY (DOCR) =========================
# Set the flag to 'true' to enable DOCR
enable_container_registry        = true

# =============================== DIGITALOCEAN DATABASES =================================
# Set the flag to 'true' to enable Databases
enable_databases                 = false

# ================================== ARGOCD CONFIG ==================================
enable_argocd_helm_release        = true
argocd_helm_repo                  = "https://argoproj.github.io/argo-helm"
argocd_helm_chart                 = "argo-cd"
argocd_helm_chart_version         = "7.8.2"
argocd_helm_release_name          = "argocd"
argocd_helm_chart_timeout_seconds = 600
argocd_k8s_namespace              = "argocd"

argocd_additional_helm_values_file = "../manifests/argocd-ha-helm-values.yaml"
