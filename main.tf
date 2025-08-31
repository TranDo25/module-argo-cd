terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
}

# Cấu hình Kubernetes provider cho EKS
provider "kubernetes" {
  host                   = var.kubernetes_cluster_endpoint
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_cert_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", var.kubernetes_cluster_name]
  }
}

# Helm provider KHÔNG cần block kubernetes nữa, chỉ cần để trống
provider "helm" {}

# Tạo namespace ArgoCD
resource "kubernetes_namespace" "argo" {
  metadata {
    name = "argo"
  }
}

# Cài đặt ArgoCD bằng Helm
resource "helm_release" "argocd" {
  name       = "msur"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argo.metadata[0].name
}
