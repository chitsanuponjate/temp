variable "networkid" {
  default = ["subnet-080fbe63d1b4811e6", "subnet-048d1ca369be316c4", "subnet-007b58ec4c512ec95", "subnet-09365ae13b06ee7f9"]
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

    subnet_ids = var.networkid

  }

  depends_on = [aws_iam_role_policy_attachment.amazon-eks-cluster-policy]

}


