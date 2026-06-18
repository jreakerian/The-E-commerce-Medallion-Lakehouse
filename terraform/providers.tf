# --------------------------------------------------------------------------
# Terraform Configuration for E-commerce Medallion Lakehouse
# --------------------------------------------------------------------------
# Provisions the AWS infrastructure for the data lakehouse:
#   - S3 bucket with medallion layer folder structure (bronze/silver/gold)
#   - IAM role and policy for Snowflake storage integration
#   - Public access blocking for security
# --------------------------------------------------------------------------

terraform {
  required_version = ">= 1.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # For a production setup, uncomment and configure remote state:
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "ecommerce-lakehouse/terraform.tfstate"
  #   region         = "us-east-2"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}
