resource "google_compute_firewall" "jenkins" {
  project = "nginx-328009"
  name    = "jenkins"
  network = google_compute_network.jenkins.id
   allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins"]
}