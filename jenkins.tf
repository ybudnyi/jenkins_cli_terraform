resource "google_compute_instance" "jenkins" {
  name         = "jenkins-master"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  tags         = ["jenkins"]
  boot_disk {
    initialize_params {
      image = "jenkins-agent-new"
    }  
  }
  network_interface {
    subnetwork = google_compute_subnetwork.main.id
    access_config {}
  }
  metadata = {
    ssh-keys = "yurii:${file("~/.ssh/id_rsa.pub")}"
  }
  connection {
    type     = "ssh"
    user     = "yurii"
    private_key = "${file("~/.ssh/id_rsa")}"
    host = self.network_interface.0.access_config.0.nat_ip
    agent = false
  }
  provisioner "file" {
    source      = "$(pwd)/terraform_install"
    destination = "/tmp/terraform_install"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo /tmp/terraform_install"
    ]
  }
}
output "jenkins_endpoint" {
    value = google_compute_instance.jenkins.network_interface.0.access_config.0.nat_ip  
}