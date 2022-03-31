resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
    lifecycle {
   ignore_changes = [
     server_side_encryption_configuration,
     replication_configuration,
    ]
}
   

}

resource "aws_s3_bucket_request_payment_configuration" "requester" {
  bucket = aws_s3_bucket.s3_bucket.id
  payer  = "Requester"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "source_encryption" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    bucket_key_enabled = false
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "source-acl" {
  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "source-versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

