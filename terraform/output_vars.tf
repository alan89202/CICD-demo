output "bucket_name" {
  value = var.bucket_name
}

locals {
  all_instances = {
    for instance in aws_instance :
    instance.tags["Name"] => instance.public_ip 
    if instance.tags["Name"] != null && contains(instance.tags["Name"], "vprofile")
  }
}



