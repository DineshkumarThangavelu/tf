resource "aws_iam_role" "role" {
    name               = var.role_name
    assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}


resource "aws_iam_policy" "policy" {
    name        = "${var.role_name}-policy"
    description = "${var.role_name}-policy"
    policy      = data.aws_iam_policy_document.defined_policy.json
}

resource "aws_iam_role_policy_attachment" "policy-attach" {
    role       = aws_iam_role.role.name
    policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_role_policy_attachment" "policy-attach-ssm" {
    role  = aws_iam_role.role.name
    policy_arn = data.aws_iam_policy.ssm_access_policy.arn
}
resource "aws_iam_role_policy_attachment" "policy-attach-s3-fullaccess" {
    role  = aws_iam_role.role.name
    policy_arn = data.aws_iam_policy.s3_fullaccess_policy.arn
}

resource "aws_iam_instance_profile" "iam_profile" {
    name = var.role_name
    role = aws_iam_role.role.name
}
