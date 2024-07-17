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
          "s3:ListBucket",
          "s3:PutObject", 
          "s3:DeleteObject",         
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name_transactions}",
          "arn:aws:s3:::${var.bucket_name_transactions}/*",
          "arn:aws:s3:::${var.bucket_name_customers}",
          "arn:aws:s3:::${var.bucket_name_customers}/*",
          "arn:aws:s3:::${var.bucket_name_logs}",
          "arn:aws:s3:::${var.bucket_name_logs}/*",
          "arn:aws:s3:::${var.bucket_name_athena_results}",
          "arn:aws:s3:::${var.bucket_name_athena_results}/*",
          "arn:aws:s3:::mybucket3s2",
          "arn:aws:s3:::mybucket3s2/*",
          "arn:aws:logs:*:*:*"
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

resource "aws_glue_crawler" "transactions_crawler" {
  name         = "transactions-crawler"
  database_name = "customer_data"
  role         = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://mybucket3s2/dados/originais/dados_empresas.csv"
  }

  schedule = "cron(0 12 * * ? *)"

  classifiers = []
  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}

resource "aws_glue_job" "processar_dados_empresas" {
  name        = "processar_dados_empresas"
  role_arn    = aws_iam_role.glue_role.arn
  command {
    script_location = "s3://mybucket3s2/scripts/processar_dados_empresas.py"
    name            = "glueetl"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
    "--job-bookmark-option" = "job-bookmark-enable"
    "--TempDir" = "s3://mybucket3s2/temp/"
    "--enable-metrics" = "true"
  }

  max_retries           = 1
  timeout               = 2880
  glue_version          = "2.0"
  number_of_workers     = 2
  worker_type           = "G.1X"
}