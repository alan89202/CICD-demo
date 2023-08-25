data "google_compute_image" "latest_image" {
  family  = var.family_image
  project = var.project_image  
}

resource "google_compute_instance" "jenkins_agent_node" {
  service_account {
    email  = "terraform-service-account@alvaro-demo-elastic-000001.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_write"]
  }
  count        = var.jenkins_node
  name         = "jenkins-node-${count.index}"
  machine_type = var.jenkins_agent_machine_type
  tags = var.jenkins_tags 
  allow_stopping_for_update = true
  zone = var.zone[count.index]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.latest_image.self_link
      size  = 10
      type  = "pd-standard"
    }
  }
}
