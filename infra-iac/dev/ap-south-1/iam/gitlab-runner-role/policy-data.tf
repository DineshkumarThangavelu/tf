data "aws_iam_policy_document" "defined_policy" {

  statement {
    sid = "KMSAccess"

    actions = [
      "kms:*"
    ]

    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "ECRAccess"

    actions = [
      "ecr:List*",
      "ecr:Describe*",
      "ecr:UploadLayerPart",
      "ecr:UntagResource",
      "ecr:TagResource",
      "ecr:StartLifecyclePolicyPreview",
      "ecr:StartImageScan",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
    effect    = "Allow"
  }


  statement {
    sid = "SecretsManagerAccess"

    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecrets",
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:RestoreSecret",
      "secretsmanager:RotateSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecret",
      "secretsmanager:TagResource",
      "secretsmanager:UntagResource",
    ]

    resources = ["*"]
    effect    = "Allow"
  }
  statement {
    sid = "ECSDeploymentAccess"

    actions = [
      "ecs:UpdateService",
    ]

    resources = ["*"]
    effect    = "Allow"
  }


}
