resource "google_compute_instance" "jenkins_agent_node" {
  service_account {
    email  = "terraform-service-account@alvaro-demo-elastic-000001.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_write"]
  }
  count        = var.jenkins_node
  name         = "jenkins-node-${count.index}"
  machine_type = var.master_machine_type
  tags = var.jenkins_tags 
  allow_stopping_for_update = true
  zone = var.zone[count.index]

  boot_disk {
    initialize_params {
      image = var.image
      size  = 10
      type  = "pd-standard"
    }
  }
}
