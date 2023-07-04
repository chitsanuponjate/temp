output "vpc_id" {
  value = aws_vpc.main.id

  description = "VPC id"

  sensitive = false
}

output "eks_cluster_name" {
  value = "eks"
}

output "subnet_private" {
  value = aws_subnet.private.*.id
  # value = ""
}

output "subnet_public" {
  value = aws_subnet.public.*.id
  # value = ""
}