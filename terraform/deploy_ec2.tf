//Search role
data "aws_iam_role" "existing_role" {
  name = "terraform_role"
}
resource "aws_iam_instance_profile" "terraform_profile" {
  name = "terraform_profile"
  role = data.aws_iam_role.existing_role.name
}

//Create EC2 Instances
resource "aws_instance" "db_instance" {
  ami           = data.aws_ami.centos.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.vprofile-BACKEND-SG.id]
  iam_instance_profile = aws_iam_instance_profile.terraform_profile.name
  tags = {
    Name = var.db_instance_name
    Project = var.project
    OS   = "Centos"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_NAME=$(aws ec2 describe-tags --region ${var.aws_region} --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
hostnamectl set-hostname $INSTANCE_NAME
sudo yum install tar wget unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo wget https://raw.githubusercontent.com/alan89202/CICD-demo/main/vprofile/userdata/mysql.sh -O /tmp/mysql.sh
sudo chmod +x /tmp/mysql.sh
sudo /tmp/mysql.sh

EOF
}

resource "aws_instance" "mc_instance" {
  ami           = data.aws_ami.centos.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.vprofile-BACKEND-SG.id]
  iam_instance_profile = aws_iam_instance_profile.terraform_profile.name
  tags = {
    Name = var.mc_instance_name
    Project = var.project
    OS   = "Centos"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_NAME=$(aws ec2 describe-tags --region ${var.aws_region} --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
hostnamectl set-hostname $INSTANCE_NAME
sudo yum install tar wget unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo wget https://raw.githubusercontent.com/alan89202/CICD-demo/main/vprofile/userdata/memcache.sh -O /tmp/memcache.sh
sudo chmod +x /tmp/memcache.sh
sudo /tmp/memcache.sh

EOF
}

resource "aws_instance" "rmq_instance" {
  ami           = data.aws_ami.centos.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.vprofile-BACKEND-SG.id]
  iam_instance_profile = aws_iam_instance_profile.terraform_profile.name
  tags = {
    Name = var.rmq_instance_name
    Project = var.project
    OS   = "Centos"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_NAME=$(aws ec2 describe-tags --region ${var.aws_region} --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
hostnamectl set-hostname $INSTANCE_NAME
sudo yum install tar wget unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
sudo ./aws/install
sudo wget https://raw.githubusercontent.com/alan89202/CICD-demo/main/vprofile/userdata/rabbitmq.sh -O /tmp/rabbitmq.sh
sudo chmod +x /tmp/rabbitmq.sh
sudo /tmp/rabbitmq.sh

EOF
}

resource "aws_instance" "app_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.vprofile-APP-SG.id]
  iam_instance_profile = aws_iam_instance_profile.terraform_profile.name
  tags = {
    Name = var.app_instance_name
    Project = var.project
    OS   = "Ubuntu"
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_NAME=$(aws ec2 describe-tags --region ${var.aws_region} --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=Name" --output text | cut -f5)
hostnamectl set-hostname $INSTANCE_NAME
sudo apt update
sudo apt upgrade -y
sudo apt install tar wget awscli -y
sudo wget https://raw.githubusercontent.com/alan89202/CICD-demo/main/scripts/deploy_artifact.sh -O /tmp/deploy_artifact.sh
sudo chmod +x /tmp/deploy_artifact.sh
sudo /tmp/deploy_artifact.sh "${aws_s3_bucket.vprofile_bucket.bucket}" "${var.war_file_name}" &
sudo wget https://raw.githubusercontent.com/alan89202/CICD-demo/main/vprofile/userdata/tomcat_ubuntu.sh -O /tmp/tomcat_ubuntu.sh
sudo chmod +x /tmp/tomcat_ubuntu.sh
sudo /tmp/tomcat_ubuntu.sh 

EOF
}

data "aws_ami" "centos" {
  most_recent = true
  owners = ["aws-marketplace"]
  filter {
    name   = "name"
    values = [var.centos_ami_name]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = [var.ubuntu_ami_name]
  }
}
