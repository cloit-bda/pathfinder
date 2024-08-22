variable "path" {}

locals {
  routes = yamldecode(file(var.path))
}

resource "google_compute_route" "route" {
  for_each = { for r in local.routes : r.name => r }

  name             = each.value.name
  network          = each.value.network
  dest_range       = each.value.dest_range
  next_hop_instance = each.value.next_hop_instance
  priority         = each.value.priority
  tags             = each.value.tags
}
