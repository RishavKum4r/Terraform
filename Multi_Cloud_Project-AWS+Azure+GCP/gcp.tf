resource "google_compute_network" "BITS-Project-GCP-Net" {
  name                    = "bits-demo-project-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "BITS-Project-GCP-SN" {
  name          = "bits-demo-project-sn"
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.BITS-Project-GCP-Net.self_link
}

resource "google_compute_firewall" "BITS-Project-GCP-FW" {
  name    = "bits-demo-project-fw"
  network = google_compute_network.BITS-Project-GCP-Net.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "BITS-Project-GCP-VM" {
  name         = "bits-demo-project-vm"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.BITS-Project-GCP-SN.self_link

    access_config {

    }
  }

  metadata = {
    ssh-keys = "rishav:${file("~/.ssh/devlnxvmkey.pub")}"
  }
}