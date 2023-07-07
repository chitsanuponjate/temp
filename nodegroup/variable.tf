variable "eks_cluster_name" {
  type = string
  description = "eks cluster name module"
}

# variable "subnet_private" {
#   type = list(string)
#   description = "subnet private id"
# }
# You've reached your quota for maximum Fleet Requests for this account. Launching EC2 instance failed.	

variable "node_groups" {
  type = list(object({
    cluster_name       = string
    node_group_name    = string
    desired_size       = number
    max_size           = number
    min_size           = number
    instance_types     = list(string)
    max_unavailable    = number
    role               = string
    subnet_id = list(string)
    policy_attachment = list(string)
  }))
  default = [
    {
      cluster_name       = "eks"
      node_group_name    = "private-nodes"
      desired_size       = 0
      max_size           = 1
      min_size           = 0
      instance_types     = ["t3.micro"]
      max_unavailable    = 1
      role               = "general"
      subnet_id = ["subnet-080fbe63d1b4811e6", "subnet-048d1ca369be316c4"]
      policy_attachment = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
    }
  ]
}

#  aws eks --region ap-southeast-1 update-kubeconfig --name eks --profile eksctl
#  kubectl get pod --all-namespaces
# kubectl get svc
#  kubectl edit -f kube-system configmap
#  aws eks --region ap-southeast-1 update-kubeconfig --name eks --profile test-dev