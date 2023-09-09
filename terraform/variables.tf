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

variable "app_sg" {
  description = "Tomcat Security Group"
  type        = string
}

variable "backend_sg" {
  description = "Backend Security Group"
  type        = string
}
variable "instance_type" {
  description = "EC2 instances type"
  type        = string
}
variable "db_instance_name" {
  description = "EC2 instance name used for the DB"
  type        = string
}
variable "mc_instance_name" {
  description = "EC2 instance name used for memcache"
  type        = string
}
variable "rmq_instance_name" {
  description = "EC2 instance name used for rabbitmq"
  type        = string
}
variable "app_instance_name" {
  description = "EC2 instance name used for tomcat"
  type        = string
}
variable "centos_ami_name" {
  description = "Centos AMI used"
  type        = string
}
variable "ubuntu_ami_name" {
  description = "Ubuntu AMI used"
  type        = string
}
variable "key_pair_name" {
  description = "Key pair to attach to EC2"
  type        = string
}
variable "project" {
  description = "application project name"
  type        = string
}
variable "war_file_name" {
  description = "The WAR file name"
  type        = string
}
variable "elastic_token" {
  description = "Elastic enrollment token"
  sensitive   = true
}
variable "elastic_url" {
  description = "fleet server endpoint"
  type        = string
}
