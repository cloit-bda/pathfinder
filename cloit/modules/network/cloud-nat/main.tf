variable "network" {}
variable "region" {}
variable "zone" {}
variable "pre_fix" {}
variable "nat" {}
variable "eip" {}
variable "project" {}
variable "subnet_name" {}
variable "host_project" {}

resource "google_compute_address" "nat-ip" {
  name         = "${var.eip}nat-an3"
  address_type = "EXTERNAL"
  region       = "${var.region}"
  project = "${var.host_project}"
}

resource "google_compute_router" "cloit-d-host-rou-internet" {
  name    = "${var.pre_fix}host-rou-internet"
  network = "${var.network}"
  region  = "${var.region}"
  project = "${var.host_project}"
}

resource "google_compute_router_nat" "nat" {
  name                   = "${var.nat}an3"
  router                 = google_compute_router.cloit-d-host-rou-internet.name
  region                 = "${var.region}"
  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.nat-ip.*.self_link
  min_ports_per_vm       = "32"
  enable_endpoint_independent_mapping = false
  project = "${var.host_project}"

  #  enable_dynamic_port_allocation = true  # not support
  #  max_ports_per_vm = "65535"             # not support

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
#   subnetwork {
#     name                    = "${var.subnet_name}data-ce-an3"
#     source_ip_ranges_to_nat = ["172.32.0.0/25"]
#   }
  subnetwork {
    name                    = "${var.subnet_name}ingest-dmz-an3"
    source_ip_ranges_to_nat = ["172.30.0.0/26"]
  }
  subnetwork {
    name                    = "${var.subnet_name}ingest-system-an3"
    source_ip_ranges_to_nat = ["172.30.0.64/26"]
  }
#   subnetwork {
#     name                    = "${var.subnet_name}data-cps01-an3"
#     source_ip_ranges_to_nat = ["172.32.4.0/22",]
#   }
}


resource "google_compute_router_nat" "nat-gke-an3" {
  name                   = "${var.nat}gke-an3"
  router                 = google_compute_router.cloit-d-host-rou-internet.name
  region                 = "${var.region}"
  nat_ip_allocate_option = "AUTO_ONLY"
  nat_ips                = []
  min_ports_per_vm       = "32"
  enable_endpoint_independent_mapping = false
    project = "${var.host_project}"

  #  enable_dynamic_port_allocation = true  # not support
  #  max_ports_per_vm = "65535"             # not support

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

    subnetwork {
    name                    = "${var.subnet_name}data-analytics-an3" 
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE", "LIST_OF_SECONDARY_IP_RANGES"] 
    secondary_ip_range_names = ["composer-pod", "composer-service"]
    # source_subnetwork_ip_ranges_to_nat = ["10.100.0.0/18","10.10.0.0/20"]
  }

        depends_on = [google_compute_router_nat.nat]
  }
