resource "aws_s3_bucket_replication_configuration" "source-replication" {
  role   = var.iam_replication_role
  bucket = var.bucket_name

  rule {
    id     = "${var.environment}-replication-${var.replication_region}"
    status = "Enabled"
    destination {
      bucket = var.destination_bucket_name_arn
      encryption_configuration {
        replica_kms_key_id = var.kms_key

      }
    }
    source_selection_criteria {
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }
  }

}

resource "aws_s3_bucket_notification" "replication" {
  bucket = var.bucket_name

  topic {
    id        = "${var.environment}-replication-to-${var.replication_region}"
    topic_arn = aws_sns_topic.replication.arn
    events    = ["s3:Replication:OperationFailedReplication"]
  }
}

resource "aws_sns_topic" "replication" {
  name   = var.sns_topic_name
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:${var.sns_topic_name}",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${var.bucket_name_arn}"}
        }
    }]
}
POLICY
  tags = {
    "Destination" = "${var.replication_environment}-${var.replication_region}"
  }
}

