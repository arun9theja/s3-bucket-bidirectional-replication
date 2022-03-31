# s3 Output File
  
# s3 ID resource output
output "encrypted_s3_bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

# s3 ARN resource output
output "encrypted_s3_bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

# s3 domain name output
output "encrypted_s3_bucket_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}

# s3 regional domain name output
output "encrypted_s3_bucket_regional_domain_name" {
  value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}

# s3 hosted zone ID output
output "encrypted_s3_bucket_hosted_zone_id" {
  value = aws_s3_bucket.s3_bucket.hosted_zone_id
}

# s3 region output
output "encrypted_s3_bucket_region" {
  value = aws_s3_bucket.s3_bucket.region
}

# s3 website endpoint output
output "encrypted_s3_bucket_website_endpoint" {
  value = aws_s3_bucket.s3_bucket.website_endpoint
}

# s3 website domain output
output "encrypted_s3_bucket_website_domain" {
  value = aws_s3_bucket.s3_bucket.website_domain
}
