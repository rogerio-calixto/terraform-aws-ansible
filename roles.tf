resource "aws_iam_policy" "s3-rw-policy" {
  name        = "s3-rw-policy"
  path        = "/"
  description = "Read Write S3 permitions"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:Put*"
            ],
            "Resource": "*"
        }
    ]
    })
}

resource "aws_iam_role" "ec2_rw_s3_role" {
  name = "${var.project}-EC2-Acess-S3-Role"
  managed_policy_arns = [
    "${aws_iam_policy.s3-rw-policy.arn}"
  ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}