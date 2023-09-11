output "bucket_name" {
  value = var.bucket_name
}

locals {
  all_instances = merge(
    {for i in [aws_instance.db_instance]: i.tags["Name"] => {"public_ip" = i.public_ip, "os" = i.tags["OS"]}},
    {for i in [aws_instance.mc_instance]: i.tags["Name"] => {"public_ip" = i.public_ip, "os" = i.tags["OS"]}},
    {for i in [aws_instance.rmq_instance]: i.tags["Name"] => {"public_ip" = i.public_ip, "os" = i.tags["OS"]}},
    {for i in [aws_instance.app_instance]: i.tags["Name"] => {"public_ip" = i.public_ip, "os" = i.tags["OS"]}}
  )
}

output "instances" {
  value = {for k, v in local.all_instances: k => v if k != null && contains(k, "vprofile")}
}
