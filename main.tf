# Terraform provider and version update

terraform {
  required_providers {
    google = {
      source = "hashicorp/gcp"
      version = "6.10.0"
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
  credentials = file("<YOUR_CREDENTIALS_JSON_PATH>")
  project     = "<YOUR_PROJECT_ID>"
  region      = "us-central1"
}

# Create a VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks  = false
}

# Create a Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
}

# Create a Compute Engine VM instance
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

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
  storage_class = "STANDARD"
  force_destroy = true
}

