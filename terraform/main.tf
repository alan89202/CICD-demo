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
data "http" "ipinfo" {
  url = "https://ipinfo.io"
  request_headers = {
    Accept = "application/json"
  }
}

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
resource "aws_security_group" "vprofile-APP-SG" {
  name        = var.app_sg
  description = "Security group for tomcat application"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-ELB-SG.id]  
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", jsondecode(data.http.ipinfo.response_body).ip)]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", jsondecode(data.http.ipinfo.response_body).ip)]
  }
}
resource "aws_security_group" "vprofile-BACKEND-SG" {
  name        = var.backend_sg
  description = "Security group for tomcat application"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-APP-SG.id]  
  }
  ingress {
    from_port   = 11211
    to_port     = 11211
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-APP-SG.id]  
  }
  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    security_groups = [aws_security_group.vprofile-APP-SG.id]  
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true  
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [format("%s/32", jsondecode(data.http.ipinfo.response_body).ip)]
  }
}
//Create EC2 Instances
resource "aws_instance" "db_instance" {
  ami           = data.aws_ami.centos.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.vprofile-BACKEND-SG.id]
  tags = {
    Name = var.db_instance_name
    Project = var.project
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.centos_ami_name]
  }

  owners = ["amazon"]
}
