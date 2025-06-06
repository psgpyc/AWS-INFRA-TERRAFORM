data "aws_caller_identity" "current" {}

module "source_bucket" {
    source = "./s3"
    bucket_name = "psgpyc-t-source-bucket-xxx"
  
}

module "destination_bucket" {

    source = "./s3"

    bucket_name = "psgpyc-t-destination-bucket-xxx"
  
}


module "iam_role_and_policy_create" {
     
    source = "./iam"

    iam_role_name = "bucket_objects_replication_role"
    iam_role_policy = file("./policies/s3_assume_role_policy.json")

    iam_policy_name = "allow_bucket_object_replication"
    iam_policy = templatefile(
        "./policies/s3_replication_policy.json.tpl",
        {
            source_bucket_name = module.source_bucket.bucket_name
            destination_bucket_name = module.destination_bucket.bucket_name
        }
    )
  
}

resource "aws_s3_bucket_replication_configuration" "replication" {

    role = module.iam_role_and_policy_create.iam_role_arn
    bucket = module.source_bucket.bucket_id

    rule {
      id = "EnableReplication"

      status = "Enabled"

      destination {
        bucket = module.destination_bucket.bucket_arn
        storage_class = "STANDARD"
      }
    }
  
}


resource "aws_s3_bucket_lifecycle_configuration" "this" {

    bucket = module.source_bucket.bucket_id

    depends_on = [module.source_bucket]

    rule {
        id = "config"

        filter { } #forward compatibility

        status = "Enabled"

        # current object transistion or expiration

        transition {
          days = 30
          storage_class = "STANDARD_IA"
        }


       transition {
         days = 120
         storage_class = "GLACIER_IR"
       }

       transition {
         days = 365
         storage_class = "DEEP_ARCHIVE"
       }

       noncurrent_version_transition {
        noncurrent_days = 30
        storage_class = "GLACIER_IR"
       }

       noncurrent_version_transition {
         noncurrent_days = 180
         storage_class = "DEEP_ARCHIVE"
       }

       noncurrent_version_expiration {
         noncurrent_days = 365
       }


    }   
}

resource "aws_kms_key" "this" {
  description = "CMK KMS Key"
  enable_key_rotation = true
  deletion_window_in_days = 30
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = templatefile(
    "./policies/s3_kms_key_policy.json.tpl",
    {
      caller_account_id = data.aws_caller_identity.current.account_id
    }

  )
  
}




