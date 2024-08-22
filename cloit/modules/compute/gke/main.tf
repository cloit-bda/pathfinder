variable "network" {}
variable "network_name" {}
variable "subnet_name" {}
variable "region" {}
variable "zone_a" {}
variable "zone_b" {}
variable "pre_fix" {}
variable "ingest_project" {}
variable "service_project" {}
variable "project_name" {}
variable "host_project" {}
variable "machine_spec" {}
variable "boot_disk_size" {}
variable "boot_disk_image" {}
variable "boot_disk_type" {}
variable "ssh_keys" {}
variable "subnet_url" {}
variable "image_type" {}
variable "service_project_number" {}

resource "google_service_account" "dive_gke_service_service" {
  account_id   = "${var.pre_fix}service-gsa-dive-gke"
  display_name = "${var.pre_fix}service-gsa-dive-gke"
  project      = var.service_project
}

resource "google_project_iam_member" "dive_gke_an_network_user1" {
  project = var.host_project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${var.service_project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "dive_gke_an_network_user2" {
  project = var.host_project
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${var.service_project_number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "dive_gke_an_network_user3" {
  project = var.host_project
  role    = "roles/container.serviceAgent"
  member  = "serviceAccount:service-${var.service_project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_container_cluster" "service-dive-gke-an3-001" {
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = false

  name                  = "${var.pre_fix}service-dive-gke-an3-001"
  project               = var.service_project
  location              = var.region
  network               = var.network
  subnetwork            = "${var.subnet_url}/${var.subnet_name}service-gke-dive-an3"
  node_locations        = [var.zone_a ,var.zone_b]
  enable_shielded_nodes = "true"

  ip_allocation_policy {
    cluster_secondary_range_name  = "dive-pod"
    services_secondary_range_name = "dive-service"
  }

  min_master_version        = "1.23.5-gke.1501" # 1.21.6-gke.1503 / 1.23.5-gke.1501
  default_max_pods_per_node = "110"

  release_channel {
    channel = "REGULAR"
  }

  networking_mode             = "VPC_NATIVE"
  enable_intranode_visibility = "false"
  master_authorized_networks_config {
    cidr_blocks {
      display_name = "cli"
      cidr_block   = "172.30.0.11/32"
    }
  }

  node_pool {
    initial_node_count = 1
    node_config {
      disk_size_gb    = "100"
      disk_type       = var.boot_disk_type
      image_type      = var.image_type
      machine_type    = var.machine_spec
      service_account = google_service_account.dive_gke_service_service.email
      oauth_scopes    = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
      tags = ["${var.pre_fix}service-net-dive-gke"]
    }
    upgrade_settings {
      max_surge       = "1"
      max_unavailable = "0"
    }
  }

  workload_identity_config {
#    workload_pool = "${var.project_name}-service.svc.id.goog"
#    workload_pool = "cloit-service.svc.id.goog"
  }

  private_cluster_config {
    enable_private_endpoint = "true"
    enable_private_nodes    = "true"
    master_ipv4_cidr_block  = "172.16.30.0/28"
  }
  depends_on = [
    google_project_iam_member.dive_gke_an_network_user1, google_project_iam_member.dive_gke_an_network_user2,
    google_project_iam_member.dive_gke_an_network_user3
  ]
}


