//Create S3 Bucket to save agents and artifacts
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

//Create security groups used within application
resource "aws_security_group" "vprofile-ELB-SG" {
  name        = var.elb_sg
  description = "Security group for ELB"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}
