resource "aws_iam_instance_profile" "ec2-profile" {
  name = "${var.project}-ec2_profile"
  role = aws_iam_role.ec2_rw_s3_role.name
}