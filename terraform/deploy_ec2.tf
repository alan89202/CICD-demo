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
  user_data = <<EOF
#!/bin/bash
sudo yum install wget -y
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
  tags = {
    Name = var.mc_instance_name
    Project = var.project
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
sudo yum install wget -y
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
  tags = {
    Name = var.rmq_instance_name
    Project = var.project
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
sudo yum install wget -y
sudo wget https://raw.githubusercontent.com/alan89202/CICD-demo/main/vprofile/userdata/rabbitmq.sh -O /tmp/rabbitmq.sh
sudo chmod +x /tmp/rabbitmq.sh
sudo /tmp/rabbitmq.sh
EOF
}

resource "aws_instance" "app_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.vprofile-BACKEND-SG.id]
  tags = {
    Name = var.app_instance_name
    Project = var.project
  }
  root_block_device {
    volume_size = 10
    volume_type = "gp2"
  }
  user_data = <<EOF
#!/bin/bash
sudo yum install wget -y
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