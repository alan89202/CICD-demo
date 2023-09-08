output "bucket_name" {
  value = var.bucket_name
}

data "http" "ip" {
  url = "https://ipinfo.io"
}

output "my_public_ip" {
  value = "format("%s/32", jsondecode(data.http.ip.body).ip)"
}
