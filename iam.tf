resource "aws_iam_role" "replication" {
  name = "s3_replication_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "s3-replication"
  }
}

resource "aws_iam_policy" "replication" {
  name   = "s3-replication-policy"
  path   = "/acct-managed/"
  policy = data.template_file.policy.rendered
}

data "template_file" "policy" {
  template = file("${path.module}/files/replication-policy.tpl")
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}