variable "path" {}

locals {
  nat_data = [for nat in split("---", file(var.path)) : yamldecode(nat) if nat != ""]
}

resource "google_compute_router_nat" "cloud_nat" {
  for_each = { for nat in local.nat_data : nat.name => nat }

  name   = each.value.name
  router = each.value.router

  enable_endpoint_independent_mapping = each.value.enableEndpointIndependentMapping
  enable_dynamic_port_allocation      = each.value.enableDynamicPortAllocation
  icmp_idle_timeout_sec               = each.value.icmpIdleTimeoutSec
  tcp_established_idle_timeout_sec   = each.value.tcpEstablishedIdleTimeoutSec
  tcp_transitory_idle_timeout_sec    = each.value.tcpTransitoryIdleTimeoutSec
  udp_idle_timeout_sec               = each.value.udpIdleTimeoutSec
  tcp_time_wait_timeout_sec          = lookup(each.value, "tcpTimeWaitTimeoutSec", null)
  max_ports_per_vm                   = lookup(each.value, "maxPortsPerVm", null)
  min_ports_per_vm                   = lookup(each.value, "minPortsPerVm", null)

  nat_ip_allocate_option             = each.value.natIpAllocateOption
  source_subnetwork_ip_ranges_to_nat = each.value.sourceSubnetworkIpRangesToNat
  nat_ips = [for ip in lookup(each.value, "nat_ips", []) : element(split("/", ip), length(split("/", ip)) - 1)]


  dynamic "subnetwork" {
    for_each = each.value.subnetworks

    content {
      name                   = element(split("/", subnetwork.value.name), length(split("/", subnetwork.value.name)) - 1)
      source_ip_ranges_to_nat = subnetwork.value.sourceIpRangesToNat
    }
  }

  dynamic "log_config" {
    for_each = [each.value.log_config]

    content {
      enable = log_config.value.enable
      filter = log_config.value.filter
    }
  }
}
