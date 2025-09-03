variable "kubernetes_cluster_id" {
  type = string
}
variable "kubernetes_cluster_cert_data" {
  type = string
}
variable "kubernetes_cluster_endpoint" {
  type = string
}
variable "kubernetes_cluster_name" {
  type = string
}
variable "eks_nodegroup_id" {
  type = string
}
variable "aws_region" {
  description = "AWS region để deploy resource"
  type        = string
  default     = "ap-southeast-1" # Singapore (gần VN)
}
