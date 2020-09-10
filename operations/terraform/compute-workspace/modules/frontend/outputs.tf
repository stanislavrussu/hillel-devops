output "aws_s3_bucket" {
  value = aws_s3_bucket.this.id
}

output "cf_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}