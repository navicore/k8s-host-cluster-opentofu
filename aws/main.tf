provider "aws" {
  region = var.aws_region
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# IAM Role for Node Group
resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

# Networking Resources
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet" {
  count           = 2
  vpc_id          = aws_vpc.vpc.id
  cidr_block      = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

data "aws_availability_zones" "available" {}

# EKS Cluster
resource "aws_eks_cluster" "host_cluster" {
  name     = "navinet"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.subnet[*].id
  }

  version = "1.31"
}

# EKS Node Group
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.host_cluster.name
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = aws_subnet.subnet[*].id
  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 4
  }
  instance_types = ["t3.medium"]
  ami_type       = "AL2_x86_64"
}

# Save kubeconfig to a file
resource "local_file" "kubeconfig" {
  content  = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = aws_eks_cluster.host_cluster.name
    endpoint     = aws_eks_cluster.host_cluster.endpoint
    ca_data      = base64decode(aws_eks_cluster.host_cluster.certificate_authority[0].data)
  })
  filename = "${path.module}/kubeconfig.yaml"
}
