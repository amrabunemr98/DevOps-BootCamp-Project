# Define an AWS ECR repository
resource "aws_ecr_repository" "sprints_ecr" {
  name                 = "sprints-ecr-repo"   # Name of the ECR repository
  image_tag_mutability = "MUTABLE"   # Image tag mutability setting

  image_scanning_configuration {
    scan_on_push = true   # Enable scanning images on push
  }
}

# Define an IAM policy document for ECR permissions
data "aws_iam_policy_document" "ecr_policy" {
  statement {
    sid    = "new policy"   # Statement ID
    effect = "Allow"   # Effect of the statement

    # Specify the principals (identities) that are allowed
    principals {
      type        = "*"   # Principal type (anyone)
      identifiers = ["*"]   # Principal identifiers (anyone)
    }

    # List of allowed actions
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
      "sts:AssumeRole",
    ]
  }
}

# Attach the ECR policy document to the repository
resource "aws_ecr_repository_policy" "aws_ecr_policy" {
  repository = aws_ecr_repository.sprints_ecr.name   # Name of the ECR repository
  policy     = data.aws_iam_policy_document.ecr_policy.json   # JSON representation of the policy
}




