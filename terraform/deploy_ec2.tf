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
  owners = ["aws-marketplace"]
  filter {
    name   = "name"
    values = [var.centos_ami_name]
  }
}
