variable "public_subnet_cidr_block" {
  description = "cidr block array for subnet"
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "private_subnet_cidr_block" {
  description = "cidr block array for subnet"
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "public_subnet_tag_name" {
  description = "array for kube internal elb"
  type        = list(string)
  default     = ["public-us-east-1a", "public-us-east-1b"]
}

variable "private_subnet_tag_name" {
  description = "array for kube internal elb"
  type        = list(string)
  default     = ["private-us-east-1a", "private-us-east-1b"]
}

variable "availability_zone" {
  description = "array for availability zone"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnet_cidr_block)

  vpc_id = aws_vpc.main.id

  availability_zone = var.availability_zone[count.index]

  cidr_block = var.public_subnet_cidr_block[count.index]

  tags = {
    "Name"                                      = var.public_subnet_tag_name[count.index]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnet_cidr_block)

  vpc_id = aws_vpc.main.id

  availability_zone = var.availability_zone[count.index]

  cidr_block = var.private_subnet_cidr_block[count.index]

  tags = {
    "Name"                                      = var.private_subnet_tag_name[count.index]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# resource "aws_subnet" "private-us-east-1a" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.0.0/19"
#   availability_zone = "us-east-1a"

#   tags = {
#     "Name"                                      = "private-us-east-1a"
#     "kubernetes.io/role/internal-elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#   }
# }

# resource "aws_subnet" "private-us-east-1b" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.32.0/19"
#   availability_zone = "us-east-1b"

#   tags = {
#     "Name"                                      = "private-us-east-1b"
#     "kubernetes.io/role/internal-elb"           = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#   }
# }

# resource "aws_subnet" "public-us-east-1a" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.64.0/19"
#   availability_zone       = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                                      = "public-us-east-1a"
#     "kubernetes.io/role/elb"                    = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#   }
# }

# resource "aws_subnet" "public-us-east-1b" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.96.0/19"
#   availability_zone       = "us-east-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     "Name"                                      = "public-us-east-1b"
#     "kubernetes.io/role/elb"                    = "1"
#     "kubernetes.io/cluster/${var.cluster_name}" = "owned"
#   }
# }