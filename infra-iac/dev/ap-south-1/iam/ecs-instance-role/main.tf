data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

#     principals {
#       type = "AWS"
#
#       identifiers = [
#         "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
#       ]
#     }

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}
data "aws_iam_policy" "ecs_access_policy" {
  arn = var.iam_policy_ecs_arn
}
data "aws_iam_policy" "efs_access_policy" {
  arn = var.iam_policy_efs_arn
}
data "aws_iam_policy" "ssm_access_policy" {
  arn = var.iam_policy_ssm_arn
}
data "aws_iam_policy" "ecr_access_policy" {
  arn = var.iam_policy_ecr_arn
}