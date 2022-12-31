provider "aws" {
  region = "us-east-1"
}

resource "aws_eks_cluster" "my-cluster" {
  name = "my-cluster"
  role_arn = "arn:aws:iam::<ACCOUNT_ID>:role/<ROLE>"
  vpc_config {
    security_group_ids = [aws_security_group.my-cluster.id]
    subnet_ids = [aws_subnet.my-cluster-subnet-1.id, aws_subnet.my-cluster-subnet-2.id]
  }
}

resource "aws_iam_role" "my-cluster" {
  name = "my-cluster"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}

EOF
}

resource "aws_iam_role_policy_attachment" "my-cluster" {
  role = aws_iam_role.my-cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_vpc" "my-cluster" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "my-cluster"
  }
}

resource "aws_subnet" "my-cluster-subnet-1" {
  vpc_id = aws_vpc.my-cluster.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "my-cluster-subnet-1"
  }
}

resource "aws_subnet" "my-cluster-subnet-2" {
  vpc_id = aws_vpc.my-cluster.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "my-cluster-subnet-2"
  }
}

