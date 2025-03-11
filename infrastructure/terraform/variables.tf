# ===================== DO CONFIG VARS =======================
variable "digital_ocean_token" {
  description = "Personal Access Token to access the DigitalOcean API"
}

variable "kubeconfig_path" {
  description = "The path to save the kubeconfig to"
  default     = "~/.kube/config"
}

# ===================== DOKS CONFIG VARS =======================

variable "doks_cluster_name_prefix" {
  type        = string
  default     = "k8s-bootstrapper"
  description = "DOKS cluster name prefix value (a random suffix is appended automatically)"
}

variable "doks_k8s_version" {
  type        = string
  default     = "1.29.1-do.0"
  description = "DOKS Kubernetes version"
}

variable "doks_cluster_region" {
  type        = string
  default     = "ams3"
  description = "DOKS region name"
}

variable "doks_default_node_pool" {
  type = map(any)
  default = {
    name       = "bootstrapper-default"
    node_count = 3
    size       = "s-2vcpu-4gb"
    auto_scale = true
    min_nodes = 3
    max_nodes = 5
  }
  description = "DOKS cluster default node pool configuration"
  validation {
    condition     = var.doks_default_node_pool["node_count"] >= var.doks_default_node_pool["min_nodes"]
    error_message = "This application requires at least ${var.doks_default_node_pool["min_nodes"]} nodes in the cluster."
  }
  validation {
    condition     = var.doks_default_node_pool["node_count"] <= var.doks_default_node_pool["max_nodes"]
    error_message = "This application allows at most ${var.doks_default_node_pool["max_nodes"]} nodes in the cluster."
  }
}

variable "doks_additional_node_pools" {
  type        = map(any)
  default     = {}
  description = "DOKS cluster extra node pool configuration"
}

# ===================== DOCR CONFIG VARS =======================
variable "container_registry_name" {
  type    = string
  default = "ifarrier-cr"
}

variable "enable_container_registry" {
  type        = bool
  default     = true
  description = "Enable/disable DigitalOcean Container Registry"
}

# ===================== DigitalOcean Databases CONFIG VARS =======================
variable "enable_databases" {
  type        = bool
  default     = false
  description = "Enable/disable DigitalOcean Databases"
}

# DigitalOcean Database Cluster
variable "database_cluster_name_prefix" {
  type        = string
  default     = "bootstrapper-db"
  description = "DigitalOcean Databases cluster name"
}

variable "database_cluster_engine" {
  type        = string
  default     = "pg" #postgres
  description = "DigitalOcean Databases cluster engine"
}

variable "database_cluster_size" {
  type        = string
  default     = "db-s-1vcpu-1gb"
  description = "DigitalOcean Databases cluster size"
}

variable "database_cluster_region" {
  type        = string
  default     = "nyc3"
  description = "DigitalOcean Databases cluster region"
}

variable "database_cluster_version" {
  type        = string
  default     = "16"
  description = "DigitalOcean Databases cluster version"
}

variable "database_cluster_node_count" {
  type        = number
  default     = 1
  description = "DigitalOcean Databases cluster node count"
}

# ===================== ARGOCD HELM CONFIG VARS =======================

variable "enable_argocd_helm_release" {
  type        = bool
  default     = true
  description = "Enable/disable ArgoCD Helm chart deployment on DOKS"
}

variable "argocd_helm_repo" {
  type        = string
  default     = "https://argoproj.github.io/argo-helm"
  description = "ArgoCD Helm chart repository URL"
}

variable "argocd_helm_chart" {
  type        = string
  default     = "argo-cd"
  description = "argocd Helm chart name"
}

variable "argocd_helm_release_name" {
  type        = string
  default     = "argocd"
  description = "argocd Helm release name"
}

variable "argocd_helm_chart_version" {
  type        = string
  default     = "7.8.9"
  description = "ArgoCD Helm chart version to deploy"
}

variable "argocd_helm_chart_timeout_seconds" {
  type        = number
  default     = 300
  description = "Timeout value for Helm chart install/upgrade operations"
}

variable "argocd_k8s_namespace" {
  type        = string
  default     = "argocd"
  description = "Kubernetes namespace to use for the argocd Helm release"
}

variable "argocd_additional_helm_values_file" {
  type        = string
  default     = "argocd-ha-helm-values.yaml"
  description = "Additional Helm values to use"
}
