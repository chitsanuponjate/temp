variable "eks_cluster_name" {
  type = string
  description = "eks cluster name module"
}

variable "subnet_private" {
  type = list(string)
  description = "subnet private id"
}

variable "node_groups" {
  type = list(object({
    cluster_name       = string
    node_group_name    = string
    capacity_type      = string
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
      capacity_type      = "SPOT"
      desired_size       = 1
      max_size           = 5
      min_size           = 0
      instance_types     = ["t3.small"]
      max_unavailable    = 1
      role               = "general"
      subnet_id = ["subnet-054fa1535f5c5fbd4", "subnet-00e237cc33c8bafb0"]
      policy_attachment = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
    }
  ]
}
