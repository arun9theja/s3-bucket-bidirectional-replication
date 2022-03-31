module "s3_bucket" {
  source      = "./module/s3-bucket"
  environment = var.environment
  region      = var.region
  bucket_name = "${var.environment}-devops4solutions-upload-bucket"
  kms_key     = data.aws_kms_key.basic-key.arn

}

module "s3_bucket_dr" {
  depends_on = [module.s3_bucket]
  providers = {
    aws = aws.secondary
  }
  region      = var.replication_region
  source      = "./module/s3-bucket"
  environment = "${var.environment}-dr"
  bucket_name = "${var.environment}-devops4solutions-upload-bucket-dr"
  kms_key     = data.aws_kms_key.basic-key-replication.arn

}

module "s3_bucket_enable_replication" {
  depends_on = [module.s3_bucket_dr]

  source                      = "./module/s3-bidirectional"
  environment                 = var.environment
  region                      = var.region
  bucket_name_arn             = module.s3_bucket.encrypted_s3_bucket_arn
  destination_bucket_name_arn = module.s3_bucket_dr.encrypted_s3_bucket_arn
  bucket_name                 = module.s3_bucket.encrypted_s3_bucket_id
  destination_bucket_name     = module.s3_bucket_dr.encrypted_s3_bucket_id
  iam_replication_role        = aws_iam_role.replication.arn
  sns_topic_name              = "devops4solutions-s3-replication-${var.environment}-to-${var.replication_region}"
  replication_environment     = "${var.environment}-dr"
  replication_region          = var.replication_region
  kms_key                     = data.aws_kms_key.basic-key-replication.arn


}

module "s3_bucket_enable_replication_dr" {
  providers = {
    aws = aws.secondary
  }
  depends_on                  = [module.s3_bucket_enable_replication]
  source                      = "./module/s3-bidirectional"
  environment                 = "${var.environment}-dr"
  region                      = var.replication_region
  bucket_name_arn             = module.s3_bucket_dr.encrypted_s3_bucket_arn
  destination_bucket_name_arn = module.s3_bucket.encrypted_s3_bucket_arn
  bucket_name                 = module.s3_bucket_dr.encrypted_s3_bucket_id
  destination_bucket_name     = module.s3_bucket.encrypted_s3_bucket_id
  iam_replication_role        = aws_iam_role.replication.arn
  sns_topic_name              = "devops4solutions-s3-replication-${var.environment}-dr-to-${var.region}"
  replication_environment     = var.environment
  replication_region          = var.region
  kms_key                     = data.aws_kms_key.basic-key.arn
}

resource "aws_s3_bucket_object" "example" {
  depends_on = [module.s3_bucket_enable_replication_dr]

  key        = "someobject"
  bucket     = module.s3_bucket.encrypted_s3_bucket_id
  source     = "README.md"
  kms_key_id = data.aws_kms_key.basic-key.arn
}




