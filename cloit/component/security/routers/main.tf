variable "path" {}

locals {
  router_data = yamldecode(file(var.path))
}


resource "google_compute_router" "router" {
  name    = "cloit-d-host-rou-internet"
  region  = "asia-northeast3"
  network = "cloit-d-host-vpc"

  #  project = "cloit-host-dev"
  # Additional configurations like BGP can be added here if needed.

  # Example BGP configuration:
  # bgp {
  #   asn = "YOUR_ASN_NUMBER"
  #   advertise_mode = "DEFAULT"
  # }
}

#resource "google_compute_router" "router" {
#  name    = local.router_data.name
#  network = basename(local.router_data.network)
#  region  = basename(local.router_data.region)
#
#  dynamic "nat" {
#    for_each = local.router_data.nats
#
#    content {
#      name                   = nat.value.name
#      nat_ip_allocate_option = nat.value.natIpAllocateOption
#
#      dynamic "nat_ips" {
#        for_each = nat.value.natIps
#        content {
#          nat_ip = basename(nat_ips.value)
#        }
#      }
#
#      dynamic "subnetwork" {
#        for_each = nat.value.subnetworks
#        content {
#          name = basename(subnetwork.value.name)
#
#          dynamic "source_ip_ranges_to_nat" {
#            for_each = subnetwork.value.sourceIpRangesToNat
#            content {
#              range = source_ip_ranges_to_nat.value
#            }
#          }
#        }
#      }
#    }
#  }
#}

