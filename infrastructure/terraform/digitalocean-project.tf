resource "digitalocean_project" "playground" {
  name        = "iFarrier"
  description = "iFarrier Kubernetes Cluster"
  purpose     = "Framework to build a production-grade setup"
  environment = "Production"
  resources   = [digitalocean_kubernetes_cluster.bootstrapper.urn]
}