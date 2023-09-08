resource "aws_s3_bucket_acl" "vprofile_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

