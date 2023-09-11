output "bucket_name" {
  value = var.bucket_name
}

locals {
  all_instances = {
    for instance in aws_instance:
      instance.tags["Name"] => {
        "public_ip" => instance.public_ip,
        "os" => instance.tags["OS"]
      }
    if instance.tags["Name"] != null && contains(instance.tags["Name"], "vprofile")
  }
}


output "instances" {
  value = local.all_instances
}


