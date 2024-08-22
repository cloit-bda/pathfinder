variable "pre_fix" {}
variable "host_project" {}
variable "network" {}

resource "google_compute_global_address" "private_connect_ip_range" {
  name          = "${var.pre_fix}host-gcp-connection"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network
  address = "10.240.0.0"
}

resource "google_service_networking_connection" "mysql_network_connect" {
  network                 = var.network
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_connect_ip_range.name]
}
