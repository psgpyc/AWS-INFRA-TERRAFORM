resource "aws_s3_bucket" "this" {
    bucket = var.bucket_name

    tags = {

      "origin":  "source"
    }
  
}

resource "aws_s3_bucket_versioning" "this" {

    bucket = aws_s3_bucket.this.id

    versioning_configuration {
      status = "Enabled"
    }

    depends_on = [ aws_s3_bucket.this ]
  
}

