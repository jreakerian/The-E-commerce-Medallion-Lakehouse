variable "aws_region" {
    description = " The AWS region where the lakehouse infrastructure will be deployed"
    type = string
    default = "us-east-2"
}

variable "lakehouse_bucket_name"{
    description = "The globally unique name for the S3 Bucket housing the medallion Architecture"
    type = string
    default = "project-ecommerce-lakehouse"
}

variable "snowflake_iam_user_arn" {
  description = "The AWS_IAM_USER_ARN provided by Snowflake after DESCRIBE INTEGRATION. Leave empty for initial bootstrap."
  type        = string
  default     = "arn:aws:iam::724937262037:user/g6qp1000-s"
}

variable "snowflake_external_id" {
  description = "The AWS_EXTERNAL_ID provided by Snowflake after DESCRIBE INTEGRATION. Leave dummy value for initial bootstrap."
  type        = string
  default     = "VQB01613_SFCRole=2_Sb48EKT+UqeGvUv1ZAPaXdDW9BM="
}