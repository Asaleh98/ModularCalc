resource "aws_s3_bucket" "cyber94_calculator2_asaleh_bucket_tf" {
  bucket = "cyber94-asaleh2-bucket"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  acl = "private"

  tags = {
    Name = "cyber94_calculator2_asaleh_bucket"
  }
}
