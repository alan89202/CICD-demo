# Google configuration
provider "google" {
  credentials = file(var.credentials)
  project     = var.project_name
}
