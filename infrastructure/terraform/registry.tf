resource "digitalocean_container_registry_docker_credentials" "registry" {
  registry_name = var.container_registry_name
}

# Create the ifarrier namespace
resource "kubernetes_namespace" "ifarrier" {
  metadata {
    name = "ifarrier"
  }
}

resource "kubernetes_secret" "registry_creds" {
  metadata {
    name      = "docker-cfg"
    namespace = "ifarrier"
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.registry.docker_credentials
  }

  type       = "kubernetes.io/dockerconfigjson"
  depends_on = [kubernetes_namespace.ifarrier]

}
