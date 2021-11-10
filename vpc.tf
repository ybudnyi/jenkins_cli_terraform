resource "google_compute_network" "jenkins" {
  project                 = "nginx-328009"
  name                    = "jenkins"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}
resource "google_compute_subnetwork" "main" {
  name          = "main"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.jenkins.id
}
