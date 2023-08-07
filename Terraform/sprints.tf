# Configure the AWS provider
provider "aws" {
  region  = "us-east-1"  # Specify your desired AWS region
  profile = "Project"   # Specify your AWS credentials profile
}

# Retrieve the latest Ubuntu AMI
data "aws_ami" "amazon_ec2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]  # Canonical
}

# Create an AWS EC2 instance
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_ec2.image_id  # Use the AMI ID from the data source
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  associate_public_ip_address = true
  key_name = "sprint-project"
  iam_instance_profile = aws_iam_instance_profile.worker.name

  tags = {
    Name = "Jenkins-Instance"
  }
}

# Create an AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Sprints-vpc"
  }
}

# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-ec2"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw-ec2" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet Gateway-ec2"
  }
}

# Create a route table for the public subnet
resource "aws_route_table" "rt-ec2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-ec2.id
  }

  tags = {
    Name = "Route Table-ec2"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "rt_a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt-ec2.id
}


# Create an AWS security group
resource "aws_security_group" "sg" {
  name   = "Terraform-sg"
  vpc_id = aws_vpc.vpc.id

  # Ingress rules
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create public subnets for EKS
resource "aws_subnet" "public_subnet1_eks" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2_eks" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

# Create route tables for EKS subnets
resource "aws_route_table" "rt-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-ec2.id
  }

  tags = {
    Name = "Route Table1-eks"
  }
}

resource "aws_route_table_association" "rt_1" {
  subnet_id      = aws_subnet.public_subnet1_eks.id
  route_table_id = aws_route_table.rt-1.id
}

resource "aws_route_table" "rt-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-ec2.id
  }

  tags = {
    Name = "Route Table2-eks"
  }
}

resource "aws_route_table_association" "rt_2" {
  subnet_id      = aws_subnet.public_subnet2_eks.id
  route_table_id = aws_route_table.rt-2.id
}



# Create an Amazon EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = "Sprints-EKS-Cluster"
  role_arn = aws_iam_role.master.arn

  # Configure the VPC and subnets for the EKS cluster
  vpc_config {
    subnet_ids = [aws_subnet.public_subnet1_eks.id, aws_subnet.public_subnet2_eks.id]
  }

  # Define dependencies for the EKS cluster creation
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}


# Create an IAM role for the EKS master
resource "aws_iam_role" "master" {
  name = "eks-master"

  # Define the assume role policy document for the EKS master role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach Amazon EKS cluster policies to the master role
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.master.name
}

# Create an IAM instance profile for connecting EKS in EC2
resource "aws_iam_instance_profile" "worker" {
  depends_on = [aws_iam_role.worker]
  name       = "worker-temp"
  role       = aws_iam_role.worker.name
}

# Create an Amazon EKS node group
resource "aws_eks_node_group" "node-grp" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "node-group"
  node_role_arn   = aws_iam_role.worker.arn
  subnet_ids      = [aws_subnet.public_subnet1_eks.id, aws_subnet.public_subnet1_eks.id]
  capacity_type   = "ON_DEMAND"
  disk_size       = "20"
  ami_type        = "AL2_x86_64"
  instance_types  = ["t2.medium"]

  # Configure remote access to instances
  remote_access {
    ec2_ssh_key               = "sprint-project"
    source_security_group_ids = [aws_security_group.sg.id]
  }

  # Define labels for the node group
  labels = tomap({ env = "default" })

  # Configure scaling settings
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  # Configure update settings
  update_config {
    max_unavailable = 1
  }

  # Define dependencies for the node group creation
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Create an IAM role for the EKS worker
resource "aws_iam_role" "worker" {
  name = "ed-eks-worker"

  # Define the assume role policy document for the EKS worker role
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Create an IAM policy for the autoscaler
resource "aws_iam_policy" "autoscaler" {
  name   = "ed-eks-autoscaler-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeTags",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach IAM policies to the EKS worker role
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "autoscaler" {
  policy_arn = aws_iam_policy.autoscaler.arn
  role       = aws_iam_role.worker.name
}





