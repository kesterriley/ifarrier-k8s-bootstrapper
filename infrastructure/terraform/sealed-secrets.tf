# Sealed Secrets Installation

# (1)
resource "kubernetes_namespace" "sealed-secrets-ns" {
  metadata {
    name = "sealed-secrets"
  }
}

# Create TLS
resource "tls_private_key" "sealed_secrets_key" {
  algorithm = "RSA"
  rsa_bits    = 4096
}

resource "tls_self_signed_cert" "sealed_secrets_cert" {
  private_key_pem = tls_private_key.sealed_secrets_key.private_key_pem
  subject {
    common_name  = var.sealed_secret_certificate_common_name
    organization = var.sealed_secret_certificate_organization
  }

  validity_period_hours = 210240
  early_renewal_hours   = 48

  allowed_uses = [
    "encipher_only"
  ]

}

# (2)
resource "kubernetes_secret" "sealed-secrets-key" {
  depends_on = [kubernetes_namespace.sealed-secrets-ns]
  metadata {
    name      = "sealed-secrets-key"
    namespace = "sealed-secrets"
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = tls_self_signed_cert.sealed_secrets_cert.cert_pem
    "tls.key" = tls_private_key.sealed_secrets_key.private_key_pem
  }
}

# (3)
resource "helm_release" "sealed-secrets" {
  depends_on = [kubernetes_secret.sealed-secrets-key]
  chart      = "sealed-secrets"
  name       = "sealed-secrets"
  namespace  = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
}