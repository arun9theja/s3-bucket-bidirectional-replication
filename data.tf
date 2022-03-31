data "aws_kms_key" "basic-key" {
  key_id = "alias/aws/s3"
}
data "aws_caller_identity" "current" {}
