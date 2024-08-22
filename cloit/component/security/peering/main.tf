variable "path" {
  description = "Path to the YAML file containing the configuration."
}

locals {
  data = yamldecode(file(var.path))
}

resource "google_compute_network_peering" "vpc_peering" {
  for_each = { for p in local.data.peerings : p.peering_name => p }

  name         = each.value.peering_name
  network      = "projects/${local.data.project_id}/global/networks/${each.value.local_network}"
  peer_network = "projects/${each.value.target_project_id}/global/networks/${each.value.target_network}"
}
