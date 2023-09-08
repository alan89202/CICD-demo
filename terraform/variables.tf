variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}
variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "aws_access_key" {
  description = "AWS Access Key"
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  sensitive   = true
}
variable "elb_sg" {
  description = "Load Balancer Security Group"
  type        = string
}
