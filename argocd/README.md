# DNS Setup for Argo CD (optional)

## Overview

To access Argo CD via an FQDN, we need to configure a few things.

### Prerequisites

- A domain (example.com)
- [Personal Access Token](https://docs.digitalocean.com/reference/api/create-personal-access-token/) for [DigitalOcean DNS](https://docs.digitalocean.com/products/networking/dns/) access

## Apply Configurations

we can patch like this:

```kubectl -n argocd patch deployment argocd-server --type json -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--insecure"] }]'```

kubectl edit deployment -n argocd argocd-server

      - args:                             
        - /usr/local/bin/argocd-server
        - --port=8080                     
        - --metrics-port=8083              
        - --insecure
        env:

```bash
# Disable internal TLS to avoid internal redirection loops from HTTP to HTTPS. The API server should run with TLS disabled.    
kubectl patch deployment -n argocd argocd-server --patch-file no-tls.yaml 
# lets-encrypt-do-dns secret required for dns01 challenge    
# @param access-token: DO access token  
kubectl create ns cert-manager && 
kubectl create -n cert-manager secret generic lets-encrypt-do-dns \    --from-literal=access-token=<insert DO access token>
```

### ArgoCD Ingress

Fill in your custom domain `- host: argocd.{{ .Values.domain }}` in the [argo-ingress.yaml](./argo-ingress.yaml)

```bash
kubectl apply -f argo-ingress.yaml
```
