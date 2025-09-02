module "source_bucket" {

    source = "./modules/s3"
    bucket_name = var.bucket_name_source

    providers = {
      aws = aws.london
    } 
}

module "destination_bucket" {

    source = "./modules/s3"

    bucket_name = var.bucket_name_destination

    providers = {
      aws = aws.paris
    }
}

module "iam_policy_for_replication" {

    source = "./modules/iam"

    providers = {
      aws = aws.london
    }

    depends_on = [ module.source_bucket, module.destination_bucket ]

    iam_role_name = var.iam_role_name

    assume_role_policy = file("./policies/bucket-replication-assume-role-policy.json")

    iam_policy_name = var.iam_policy_name

    iam_policy = templatefile("./policies/allow_replication_btwn_buckets_policy.json.tpl", 
        {
            source_bucket_arn = module.source_bucket.bucket_arn,
            destination_bucket_arn = module.destination_bucket.bucket_arn
        }

    )
}

resource "aws_s3_bucket_replication_configuration" "this" {

    depends_on = [ module.source_bucket, module.destination_bucket ]

    role = module.iam_policy_for_replication.iam_role_arn

    bucket = module.source_bucket.bucket_id

    provider = aws.london

    rule {
      id = "EnableReplicationWithNoFilter"

      filter {
        
      }

      delete_marker_replication {
        status = "Enabled"
      }

      status = "Enabled"

      destination {
        bucket = module.destination_bucket.bucket_arn
        storage_class = "STANDARD"
      }
    }
  
}


resource "aws_s3_bucket_lifecycle_configuration" "this" {

    depends_on = [ module.source_bucket ]


    bucket = module.source_bucket.bucket_id

    rule {

        id = "source-buck-config"

        filter { }  # apply to all the objects in the bucket

        # Refer to life-cycle-timeline.md for life-cycle timeline

        transition {
          days = 30   
          storage_class = "STANDARD_IA"
        }

        transition {
          days = 60 
          storage_class = "GLACIER_IR"
        }

        expiration {

          days = 150 

        }

        noncurrent_version_transition {
          noncurrent_days = 30
          storage_class = "GLACIER"
        }

        noncurrent_version_transition {
          noncurrent_days = 120
          storage_class = "DEEP_ARCHIVE"
        }

        noncurrent_version_expiration {
          noncurrent_days = 365
        }



        status = "Enabled"

        
      
    }
  
}