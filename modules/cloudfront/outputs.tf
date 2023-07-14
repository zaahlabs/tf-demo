
# Output definitions

output "cloudfront_distribution" {
  description = "cloudfront_distribution"
  value       = aws_cloudfront_distribution.cloudfront_distribution.arn
}
