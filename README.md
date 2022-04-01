# s3-bucket-bidirectional-replication
This repository will create two s3 bucket with bidirectional replicaion enabled.

# Terraform Resources
1. S3 bucket in us-east-1 region
2. S3 bucket in us-east-2 region
3. Both buckets will get created with encryption, versioning enabled and acl
3. IAM role for replication
3. Enable replication in both the buckets
4. Upload an object in source object

# Issues
There is cyclic dependency issue of enabling replication bidirectional using terraform.
This approach will help resolving that issue and enable you to create a bidirectional replication for your bucket in a one go.

