variable "region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "bucket_name_transactions" {
  description = "Bucket name for raw transactions data"
  default     = "my-company-data-raw-transactions"
}

variable "bucket_name_customers" {
  description = "Bucket name for raw customers data"
  default     = "my-company-data-raw-customers"
}

variable "bucket_name_logs" {
  description = "Bucket name for raw logs data"
  default     = "my-company-data-raw-logs"
}

variable "bucket_name_athena_results" {
  description = "Bucket name for Athena results"
  default     = "my-company-data-athena-results"
}
