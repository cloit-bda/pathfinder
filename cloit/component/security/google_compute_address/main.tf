variable "path" {
  description = "Path to the YAML file containing the configuration."
}

locals {
  data = yamldecode(file(var.path))
}

resource "google_compute_address" "static_ips" {
  for_each = { for ip in local.data.ips : ip.name => ip }

  name        = each.value.name
  project     = local.data.project_id
  region      = local.data.region
  description = each.value.description
}

output "static_ip_addresses" {
  value = { for ip in google_compute_address.static_ips : ip.name => ip.address }
}