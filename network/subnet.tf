variable "public_subnet_cidr_block" {
  description = "cidr block array for subnet"
  type        = list(string)
  default     = ["10.0.64.0/19", "10.0.96.0/19"]
}

variable "public_subnet_tag_name" {
  description = "array for kube internal elb"
  type        = list(string)
  default     = ["public-ap-southeast-1a", "public-ap-southeast-1b"]
}

variable "private_subnet_cidr_block" {
  description = "cidr block array for subnet"
  type        = list(string)
  default     = ["10.0.0.0/19", "10.0.32.0/19"]
}

variable "private_subnet_tag_name" {
  description = "array for kube internal elb"
  type        = list(string)
  default     = ["private-ap-southeast-1a", "private-ap-southeast-1b"]
}

variable "availability_zone" {
  description = "array for availability zone"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}


resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_block)

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
  count = length(var.private_subnet_cidr_block)

  vpc_id = aws_vpc.main.id

  availability_zone = var.availability_zone[count.index]

  cidr_block = var.private_subnet_cidr_block[count.index]

  tags = {
    "Name"                                      = var.private_subnet_tag_name[count.index]
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}


# แบ่งเป็นโมดูล apply 2 ครั้งเพื่อที่จพได้ค่าออกมา hardcode