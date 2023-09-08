output "bucket_name" {
  value = var.bucket_name
}

data "http" "ip" {
  url = "http://icanhazip.com"
}

output "my_public_ip" {
  value = "${chomp(data.http.ip.body)}"
}
