# Terraform provider and version update

terraform {
  required_providers {
    google = {
      source = "hashicorp/gcp"
      version = "§ > 6.10.0"
    }
  }
}

# Terraform Backend creation 

terraform {
  backend "gcs" {
    bucket  = "tf-state-dev"
    prefix  = "terraform/state"
  }
}


# Provider configuration
provider "google" {
  credentials = file("<file name>")
  project     = "project id"
  region      = "us-central1"
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  project                 = "charged-state-441016-j3"
  name                    = "vpc-network"
  auto_create_subnetworks = true
  mtu                     = 1460
}

# Create a Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"
  region        = "${var.region}"
}

# Create a Compute Engine VM instance
resource "google_compute_instance" "default" {
  name         = "vm-instance"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {
      // Ephemeral IP (auto-assign)
    }
  }
}

# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "auto-expire" {
  name          = "no-public-access-bucket"
  location      = "US"
  force_destroy = true
  public_access_prevention = "enforced"
}
