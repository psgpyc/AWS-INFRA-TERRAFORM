### 1. What is terraform state and why it is important?

Terraform state is a JSON file(stored either locally or remotely) that maps Terraform COnfigurations to real innfrastructure in the cloud.  

1. It maintains resource mapping. It tracks resource ids and metadata, so Terraform knows what exists, what to create, update or destory.  
2. It compares state file with desired configs and actual cloud infrastructure. 
3. It also caches resource attributes to avoid API calls.
4. Manage dependencies by using DAG(in-memory resource graph) to execute in correct order.

### 2. How do you manage Terraform state in team setting?

I would use remote state backend.

1. Use s3 bucket or Terraform cloud to store the .tfstate file, so that everyone can read/write from a same place
2. Use DynamoDB(with s3) or built-in locking in Terraform Cloud to prevent concurrent operation that could corrupt the state.
3. Versoning & History: Enable versoning in s3 bucket to roll back to previous state if needed.
4. Use IAM policies with s3, and use s3 KMS encryption for security.

### 3. Explain how you’d configure an S3 + DynamoDB backend for locking.

I would: 

1. Create a s3 bucket and DynamoDB table with primary key lockID for state locking.
2. I would create a backend.tf file with below config:
```
terraform {
    backend "s3" {
        bucket = "xxx"
        key = "terraform.tfstate"
        region = "eu-west-2"
        dynamodb_table = "statetable-lock"
        encrypt = true
    }
}
```

3. How it will work:
- On `terraform init`, the state is migrated to (or read from) the s3 bucket.
- Before any `plan` or `apply`, Terraform attempts to write a lock item to the DynamoDB table.
- If another process holds the lock, Terraform waits(or error when timeout), preventing concurrent writes.
- After the operation, Terraform removes the lock, allowing others to proceed.

Include from previous question as well.


### 4.  What are Terraform workspaces, and when would you choose to use workspaces rather than configuring separate backends?

Terraform workspaces are nameed instances of your state within a single backend. By defualt, we have a `default` workspace, but we can create or change/switch to other(eg: dev, test, prod).  
Terraform stores each workspace's state at a different path or a key in the backend(`terraform.tfstate/dev`, `terraform.tfstate/prod`).

Workspaces points to the same account and services and therefore only useful for multiple environment that share the same configurations. 

For co mpletely independent projects or environment (differet aws account or due to regulations), we would like to use seperate backends. 

### 5. Describe how you’d structure Terraform modules for a typical data pipeline (e.g., using S3, EMR, Redshift) to promote reusability and maintainability.

A reusable structure:

```
.
├── modules
│   ├── s3-bucket
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── emr-cluster
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   └── redshift-cluster
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
├── environments
│   ├── dev
│   │   ├── main.tf
│   │   └── terraform.tfvars
│   └── prod
│       ├── main.tf
│       └── terraform.tfvars
└── README.md

```

If i need to use different backends, then I would implement above folder structure. 
If not, it would remove the environments folder, and instead use workspaces. 

I would also implement:
1. keep logic to minimum in the 'main.tf' files outside modules
2. Consistent naming conventions



Remaining questions:

```
6. What is the Terraform workflow?

Explain terraform init, plan, apply, destroy, and what happens in each step.

7. How does Terraform handle dependencies between resources?

Describe how it builds a dependency graph (DAG) and when depends_on is explicitly needed.

8. What are data sources in Terraform?

Explain how to fetch existing infrastructure and when to use data blocks.

9. What are Terraform input and output variables, and how do you use them?

10. How do you structure your variables.tf and outputs.tf for best practice?

11. What are locals in Terraform and when should you use them?

12. What are count, for_each, and for expressions? Give examples of each.

13. Explain the difference between provider and module blocks.

14. How do you manage secrets (e.g., database passwords) securely in Terraform?

15. What is the terraform taint command and when would you use it?

16. What are lifecycle blocks and how do they impact resource changes?

17. How do you debug or inspect a failing Terraform plan?

18. Can you explain what a remote-exec and local-exec provisioner is, and when it should (or should not) be used?

19. How would you test Terraform code before deploying it to production?

20. How do you manage multiple providers (multi-cloud or multi-region) in Terraform?

21. How do you handle state drift?


```