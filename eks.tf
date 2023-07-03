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

    subnet_ids = [
      aws_subnet.private[0].id,
      aws_subnet.private[1].id,
      aws_subnet.public[0].id,
      aws_subnet.public[1].id,
    ]

  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]
}
