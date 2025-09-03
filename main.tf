terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.28"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

# ----------------------
# AWS Provider
# ----------------------
provider "aws" {
  region = var.aws_region
}

# ----------------------
# Helm Provider
# ----------------------
provider "helm" {
  kubernetes = {
    host                   = var.kubernetes_cluster_endpoint
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.kubernetes_cluster_name]
    }
  }
}

# ----------------------
# Namespace ArgoCD
# ----------------------
resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

# ----------------------
# Helm Release ArgoCD
# ----------------------
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.6" # <-- Phiên bản mới nhất của argo-cd helm chart
  namespace  = kubernetes_namespace.argo.metadata[0].name

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_namespace.argo
  ]
}
