resource "aws_s3_bucket" "transactions" {
  bucket = var.bucket_name_transactions
  acl    = "private"
}

resource "aws_s3_bucket" "customers" {
  bucket = var.bucket_name_customers
  acl    = "private"
}

resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name_logs
  acl    = "private"
}

resource "aws_s3_bucket" "athena_results" {
  bucket = var.bucket_name_athena_results
  acl    = "private"
}

resource "aws_iam_role" "glue_role" {
  name = "AWSGlueServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "glue_policy" {
  name        = "AWSGlueServicePolicy"
  description = "Policy for Glue Service Role"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name_transactions}",
          "arn:aws:s3:::${var.bucket_name_transactions}/*",
          "arn:aws:s3:::${var.bucket_name_customers}",
          "arn:aws:s3:::${var.bucket_name_customers}/*",
          "arn:aws:s3:::${var.bucket_name_logs}",
          "arn:aws:s3:::${var.bucket_name_logs}/*",
          "arn:aws:s3:::${var.bucket_name_athena_results}",
          "arn:aws:s3:::${var.bucket_name_athena_results}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "glue:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glue_role_attachment" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_policy.arn
}
