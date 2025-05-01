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
data "aws_iam_policy" "ssm_access_policy" {
  name = var.ssm_access_policy_name
}
data "aws_iam_policy" "s3_fullaccess_policy" {
  name = var.s3_fullaccess_policy_name
}
