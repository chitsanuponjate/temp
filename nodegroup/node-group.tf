variable "policy_attachment" {
  default     = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  type        = list(string)
  description = "policy attachment"

}

resource "aws_iam_role" "nodes" {
  name = "eks-node-group"

  assume_role_policy = <<POLICY
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service":"ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
    }
    POLICY
}


locals {
  transformed_policy_attachments = [
    for group in var.node_groups : group.policy_attachment
  ]
}

output "policy_attachment" {
  value = local.transformed_policy_attachments
}

# resource "aws_iam_role_policy_attachment" "nodes-policy_attachment" {
#   for_each = toset(flatten(local.transformed_policy_attachments))

#   policy_arn = each.value
#   role       = aws_iam_role.nodes.name
# }

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

  role = aws_iam_role.nodes.name


}


resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

  role = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  role = aws_iam_role.nodes.name  
}


resource "aws_eks_node_group" "nodes_group" {

  for_each = { for idx, group in var.node_groups : idx => group }

  cluster_name = each.value.cluster_name

  node_group_name = each.value.node_group_name

  node_role_arn = aws_iam_role.nodes.arn

  # capacity_type = each.value.capacity_type

  subnet_ids = each.value.subnet_id

  scaling_config {
    desired_size = each.value.desired_size

    max_size = each.value.max_size

    min_size = each.value.min_size
  }

  

  instance_types = each.value.instance_types

  update_config {
    max_unavailable = each.value.max_unavailable
  }

  labels = {
    role = each.value.role
  }

  # depends_on = local.dependsonAttachment
  # depends_on = [
  #   aws_iam_role_policy_attachment.nodes-policy_attachment[0], 
  #   aws_iam_role_policy_attachment.nodes-policy_attachment[1],
  #   aws_iam_role_policy_attachment.nodes-policy_attachment[2],
  # ]
   depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
  ]
}


