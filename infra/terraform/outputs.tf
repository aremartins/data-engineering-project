output "s3_buckets" {
  value = [
    aws_s3_bucket.transactions.bucket,
    aws_s3_bucket.customers.bucket,
    aws_s3_bucket.logs.bucket,
    aws_s3_bucket.athena_results.bucket
  ]
}

output "glue_role_arn" {
  value = aws_iam_role.glue_role.arn
}
