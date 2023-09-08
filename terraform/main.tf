resource "aws_s3_bucket" "vprofile_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_ownership_controls" "vprofile_bucket" {
  bucket = aws_s3_bucket.vprofile_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "vprofile_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.vprofile_bucket]

  bucket = aws_s3_bucket.vprofile_bucket.id
  acl    = "private"
}

