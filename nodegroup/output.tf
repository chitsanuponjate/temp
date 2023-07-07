output "eks_cluster_name" {
  value = var.eks_cluster_name
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "kubeconfig-cer" {
  value = aws_eks_cluster.eks-cluster.certificate_authority[0].data
}

# output "token" {
#   value = aws_eks_cluster.eks-cluster.
# }