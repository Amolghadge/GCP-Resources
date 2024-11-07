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
  credentials = "${credentials}"
  project     = "${project_id}"
  region      = "${region}"
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "${my-vpc-network}"
  auto_create_subnetworks  = false
}

# Create a Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"
  region        = "${region}"
}

# Create a Compute Engine VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "${vm_instance}"
  machine_type = "${machine_type}"
  zone         = "${zone}"

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
resource "google_storage_bucket" "storage_bucket" {
  name          = "my-unique-bucket-name-12345"
  location      = "US"
  storage_class = "${storage_class}"
  force_destroy = true
}

