resource "google_compute_network" "vpc_network" {
  project                 = var.gcp_project
  name                    = "demo-vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "demo-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
  depends_on = [google_compute_network.vpc_network]
}

resource "google_compute_instance" "dev-vm" {
  name                      = "devlnxvm-gcp"
  machine_type              = var.machine_type
  zone                      = var.gcp_zone
  allow_stopping_for_update = true

  tags = ["bits-demo-project-gcp"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network    = "demo-vpc-network"
    subnetwork = "demo-subnetwork"
    access_config {
      //Public IP
    }
  }

  metadata = {
    Name = "Rishav"
  }

  metadata_startup_script = "echo hi > /demo.txt"

  service_account {
    scopes = ["cloud-platform"]
  }
}

resource "google_sql_database_instance" "main" {
  name             = "main-instance"
  database_version = "POSTGRES_15"
  region           = var.gcp_region

  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "database" {
  name     = "bits-demo-database"
  instance = google_sql_database_instance.main.name
}