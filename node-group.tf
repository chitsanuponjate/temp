variable "policy_attachment" {
  default = [ "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" ]
  type = list(string)
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


resource "aws_iam_role_policy_attachment" "nodes-policy_attachment" {

  count = length(var.policy_attachment)

  policy_arn = var.policy_attachment[count.index]

  role = aws_iam_role.nodes.name

}

locals {
  subnet_ids = [for subnet in aws_subnet.private : subnet.id]
}

locals {
  dependsonAttachment = [for attach in aws_iam_role_policy_attachment.nodes-policy_attachment : attach]
}

resource "aws_eks_node_group" "private-nodes" {

    # count      = length(var.private_subnet_cidr_block)

    # subnet_ids = aws_subnet.private[count.index].id

 
    cluster_name = aws_eks_cluster.eks-cluster.name
  
    node_group_name = "private-nodes"
  
    node_role_arn = aws_iam_role.nodes.arn

    capacity_type = "SPOT"

    subnet_ids = local.subnet_ids

    scaling_config {
        desired_size = 1

        max_size = 5

        min_size = 0
    }

    instance_types = ["t3.small"]

    update_config {
      max_unavailable = 1
    }

    labels = {
      role = "general"
    }
    
    # depends_on = local.dependsonAttachment
    depends_on = [
      aws_iam_role_policy_attachment.nodes-policy_attachment[0],
      aws_iam_role_policy_attachment.nodes-policy_attachment[1],
      aws_iam_role_policy_attachment.nodes-policy_attachment[2],
    ]


}