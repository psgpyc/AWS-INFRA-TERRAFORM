## Terraform State Management

Terraform uses state to determine which changes to make to your infrastructure. This state is stored by default in a local named "terraform.tfstate" file.  

The primary purpose of Terraform state is to store bindings between objects in a remote system and resource instances declared in your configs. 

When terraform creates a remote object in response to a change in congigurations, it will record the identity if that remote object against a particular resouce instance, and then potentially update or delete in response to future configuration changes.   


## Remote Backend: s3+Dynamodb

DynamoDB helps Terraform achive distributed locking through **atomic conditional writes**, a feature unique to DynamoDB.

This means:

-  Only one write can succeed at a time on a specific item.
- Terraform uses this to lock the state file and block others from acquiring it unitl the lock has been released.


When we configure remote backend with s3 + DynamoDB, Terraform itself is responsible for acquiring and releasing the lock before it writes to the .tfstate file in s3.

---

**1. Terraform apply or plan**

Terraform know the backend is: 

```
    backend "s3"{
        bucket = "bucket-name"
        key = "dev/terraform.tfstate"
        dynamodb_table = "terraform-lock-table"
    }
```

Since our key is `dev/terraform.tfstate`, our lockID becomes this. 

**2. Lock request to DynamoDB**

Terraform runs an atomic conditional PutItem in DynamoDB:

```json
{
  PutItem: {
    TableName: "terraform-lock-table",
    Item: {
      "LockID": "dev/terraform.tfstate",
      "Info": {
        "Operation": "Apply",
        "Who": "sikakakka@eltifydata.com",
        ...
      }
    },
    ConditionExpression: "attribute_not_exists(LockID)"
  }
}
```

If lockID already exists in the table:  
- The conditional check fails  
- Terraform exists with an error  
- It does not write to s3 at all  

If lockID does not exist:
- Lock is acquired
- Terraform proceeds


**3. Terraform writes to s3**

Now that terrafor  holds the lock:

- It safely reads/writes the `.tfstate` file from/to s3  
- No other terraform run can interfare  


**4. Unlocking**
Once apply finishes, Terraform deletes the LockID item from DynamoDB.

