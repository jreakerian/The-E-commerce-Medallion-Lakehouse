# Terraform — AWS Infrastructure for the Medallion Lakehouse

This directory contains the Infrastructure as Code (IaC) for the AWS resources that back the E-commerce Medallion Lakehouse.

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    AWS Account                           │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │  S3: project-ecommerce-lakehouse                   │  │
│  │  ├── bronze/    ← Raw CSV files from ingestion     │  │
│  │  ├── silver/    ← (reserved for future use)        │  │
│  │  └── gold/      ← (reserved for future use)        │  │
│  │  🔒 All public access blocked                      │  │
│  │  🔐 AES-256 server-side encryption                 │  │
│  └────────────────────────────────────────────────────┘  │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │  IAM: SnowflakeStorageIntegrationRole              │  │
│  │  → AssumeRole trust for Snowflake principal        │  │
│  │  → LakehouseReadWritePolicy (s3:Get/Put/Delete/    │  │
│  │    List on the lakehouse bucket)                    │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
         ▲
         │ sts:AssumeRole (ExternalId verified)
         │
┌────────┴─────────┐
│    Snowflake     │
│  STORAGE         │
│  INTEGRATION     │
└──────────────────┘
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.15.0
- AWS CLI configured with credentials (`aws configure`)
- A Snowflake storage integration created — you'll need the IAM user ARN and External ID from `DESCRIBE INTEGRATION <name>`

## Usage

```bash
# 1. Initialize Terraform (downloads the AWS provider)
terraform init

# 2. Copy the example tfvars and fill in your Snowflake integration values
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 3. Preview the changes
terraform plan -var-file="terraform.tfvars"

# 4. Apply
terraform apply -var-file="terraform.tfvars"
```

## Resources Managed

| Resource | Type | Purpose |
|----------|------|---------|
| `aws_s3_bucket.data_lake` | S3 Bucket | Data lakehouse storage with AES-256 encryption |
| `aws_s3_bucket_public_access_block.data_lake_privacy` | Public Access Block | Blocks all public access to the bucket |
| `aws_s3_object.medallion_layers` | S3 Objects | Creates `bronze/`, `silver/`, `gold/` prefixes |
| `aws_iam_role.snowflake_role` | IAM Role | Role assumed by Snowflake via storage integration |
| `aws_iam_policy.lakehouse_rw_policy` | IAM Policy | Read/write permissions scoped to the lakehouse bucket |
| `aws_iam_role_policy_attachment.snowflake_s3_attachment` | Attachment | Links the policy to the Snowflake role |

## Outputs

| Output | Description |
|--------|-------------|
| `s3_bucket_name` | Name of the lakehouse S3 bucket |
| `s3_bucket_arn` | ARN of the lakehouse S3 bucket |
| `snowflake_integration_role_arn` | IAM role ARN to use in Snowflake's `CREATE STORAGE INTEGRATION` |

## Security Notes

- **Never commit** `terraform.tfvars` or `terraform.tfstate` — both are excluded via `.gitignore`
- Snowflake integration variables are marked `sensitive` in Terraform to prevent them from appearing in plan output
- The S3 bucket has `force_destroy = true` for development convenience — set to `false` in production
