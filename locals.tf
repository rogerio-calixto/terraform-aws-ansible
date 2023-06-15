data "aws_caller_identity" "current" {}

locals {
  aws_profile = "devops"
  accountid   = data.aws_caller_identity.current.id
}