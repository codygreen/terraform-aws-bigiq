#
# Create IAM Role
#

data "aws_iam_policy_document" "bigiq_role" {
  version = "2012-10-17"
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bigiq_role" {
  name               = format("%s-bigiq-role", var.prefix)
  assume_role_policy = data.aws_iam_policy_document.bigiq_role.json

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "bigiq_profile" {
  name = format("%s-bigiq-profile", var.prefix)
  role = aws_iam_role.bigiq_role.name
}

data "aws_iam_policy_document" "bigiq_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      data.aws_secretsmanager_secret.password.arn
    ]
  }
}

resource "aws_iam_role_policy" "bigiq_policy" {
  name   = format("%s-bigiq-policy", var.prefix)
  role   = aws_iam_role.bigiq_role.id
  policy = data.aws_iam_policy_document.bigiq_policy.json
}
