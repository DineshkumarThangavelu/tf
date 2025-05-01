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
    sid = "CloudWatchAccess"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = ["arn:aws:logs:*:*:*"]
    effect    = "Allow"
  }


}
