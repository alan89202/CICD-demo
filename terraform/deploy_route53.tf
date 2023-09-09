data "aws_vpc" "default" {
  default = true
}

# Identify application instances
data "aws_instances" "vprofile" {
  filter {
    name   = "tag:Name"
    values = ["vprofile-*"]
  }
}

# Create zone
resource "aws_route53_zone" "private_zone" {
  name         = "vprofile.in"
  vpc {
    vpc_id = data.aws_vpc.default.id
  }
}

data "aws_instance" "vprofile_instances" {
  count = length(data.aws_instances.vprofile.ids)
  instance_id = data.aws_instances.vprofile.ids[count.index]
}

# Create records into private zone
resource "aws_route53_record" "vprofile_records" {
  count   = length(data.aws_instances.vprofile.ids)
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = format("%s.vprofile.in", element(data.aws_instance.vprofile_instances.*.tags["Name"], count.index))
  type    = "A"
  ttl     = "300"
  records = [element(data.aws_instance.vprofile_instances.*.private_ip, count.index)]
}
