resource "aws_s3_bucket" "this" {

    bucket = var.bucket_name

}

resource "aws_s3_bucket_versioning" "this" {
    bucket = aws_s3_bucket.this.id

    versioning_configuration {
      status = "Enabled"
    }

    depends_on = [ aws_s3_bucket.this ]
  
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {

    bucket = aws_s3_bucket.this.id

    depends_on = [ aws_s3_bucket.this ]

    rule {
        
        id = "config"

        filter {} #forward compatibility

        status = "Enabled"

        # current object transistion or expiration

        transition {
            days          = 30
            storage_class = "STANDARD_IA"
        }


        transition {
            days          = 120
            storage_class = "GLACIER_IR"
        }

        transition {
            days          = 365
            storage_class = "DEEP_ARCHIVE"
        }

        noncurrent_version_transition {
            noncurrent_days = 30
            storage_class   = "GLACIER_IR"
        }

        noncurrent_version_transition {
            noncurrent_days = 180
            storage_class   = "DEEP_ARCHIVE"
        }

        noncurrent_version_expiration {
            noncurrent_days = 365
        }
  }
}


resource "aws_s3_bucket_policy" "this" {
    bucket = aws_s3_bucket.this.id
    policy = var.bucket_access_policy
  
}