terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}


provider "aws" {
  profile = "eksctl"
  region  = "ap-southeast-1"

  access_key = "AKIAR25PCEOZVEFOO5YL"
  secret_key = "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"
}


variable "cluster_name" {
  default = "eks-cluster"
}

variable "cluster_version" {
  default = "1.25"
}

module "NetWork" {
  source          = "./network"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
}



# module "Eks" {
#   source = "./eks"
# }

module "Nodegroup" {
  source           = "./nodegroup"
  eks_cluster_name = module.NetWork.eks_cluster_name
}

locals {
  endpoint = module.Nodegroup.endpoint
  cer      = module.Nodegroup.kubeconfig-cer
}


provider "kubernetes" {
  # host = aws_eks
  host                   = local.endpoint
  cluster_ca_certificate = base64decode(local.cer)
}

module "iam" {
  source = "./iam"
}

# resource "kubernetes_manifest" "aws-auth-configmap" {
#   manifest = yamldecode(
#     <<-EOT
#     apiVersion: v1
#     kind: ConfigMap
#     data:
#     mapUsers: |
#         - userarn: arn:aws:iam::126531806131:user/test-user
#           username: test-dev
#           groups: 
#             - developers
#     mapRoles: |
#         - groups:
#         - system:bootstrappers
#         - system:nodes
#         rolearn: arn:aws:iam::126531806131:role/eks-node-group
#         username: system:node:{{EC2PrivateDNSName}}
#     metadata:
#     creationTimestamp: "2023-07-07T08:51:36Z"
#     name: aws-auth
#     namespace: kube-system
#     resourceVersion: "6310"
#     uid: 772a8f1a-434c-4768-baa3-c074e9ddb0d3
#     EOT
#   )

#   field_manager {
#     force_conflicts = true 
#   }
# }

# module.NetWork.aws_subnet.public[0]: Creation complete after 1s [id=subnet-00d266a604c537fdb]
# module.NetWork.aws_subnet.public[1]: Creation complete after 1s [id=subnet-0100d031c3337b725]
# module.NetWork.aws_subnet.private[0]: Creation complete after 1s [id=subnet-02604f5c679be4991]
# module.NetWork.aws_subnet.private[1]: Creation complete after 1s [id=subnet-06d38ce1d7a14822a]
# test-user AccessKey: AKIAR25PCEOZQAE3COTU Secret access key: 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

#  aws eks --region ap-southeast-1 update-kubeconfig --name eks --profile eksctl
#  kubectl get pod --all-namespaces
# kubectl get svc
#  kubectl edit -f kube-system configmap
#  aws eks --region ap-southeast-1 update-kubeconfig --name eks --profile test-dev
#  kubectl edit -n kube-system configmap/aws-auth