variable "networkid" {
  default = ["subnet-054fa1535f5c5fbd4", "subnet-00e237cc33c8bafb0", "subnet-06c387910d20880f9", "subnet-038f3288022b86ad4"]
}

resource "aws_iam_role" "eks-cluster" {
  name = "eks-cluster"

  assume_role_policy = <<POLICY
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service":"eks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
      
    ]
}
    POLICY
}

resource "aws_iam_role_policy_attachment" "amazon-eks-cluster-policy" {

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role = aws_iam_role.eks-cluster.name

}

resource "aws_eks_cluster" "eks-cluster" {
  name = "eks"

  role_arn = aws_iam_role.eks-cluster.arn

  version = "1.25"

  vpc_config {

    # subnet_ids = [
    #   aws_subnet.private[0].id,
    #   aws_subnet.private[1].id,
    #   aws_subnet.public[0].id,
    #   aws_subnet.public[1].id,
    # ]
    subnet_ids = var.networkid

  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}
