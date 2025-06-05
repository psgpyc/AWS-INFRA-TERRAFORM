# aws-terraform-configs

This repository contains Terraform configurations for provisioning and managing AWS resources used in data engineering pipelines. The goal is to build modular, reusable infrastructure as code (IaC) components aligned with AWS best practices and common certification scenarios.

---

## Project Objectives

- Automate provisioning of key AWS services for data engineering workflows.
- Demonstrate real-world use cases aligned with AWS certification paths.
- Use production-grade patterns including versioning, replication, IAM least privilege, and lifecycle policies.
- Centralise reusable and composable Terraform modules for S3, IAM, Glue, Redshift, Kinesis, Lambda, and more.

## Repository Structure

```bash
aws-terraform-configs/
├── s3/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── policies/
│   │   ├── s3_assume_role_policy.json
│   │   └── s3_replication_policy.json.tpl
│   ├── modules/
│       ├── s3/
│       │   ├── main.tf
│       │   ├── variables.tf
│       │   └── outputs.tf
│       └── iam/
│           ├── main.tf
│           ├── variables.tf
│           └── outputs.tf
│   
├── glue/
│   └── ...
├── redshift/
│   └── ...
├── kinesis/
│   └── ...
├── emr/
│   └── ...
├── lambda/
│   └── ...
├── networking/
│   └── ...
├── .gitignore
├── README.md
└── versions.tf
```
