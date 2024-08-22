
resource "google_dns_managed_zone" "zone" {
  for_each = { for zone in local.dns_data.managed_zones : zone.name => zone }
  name     = each.value.name
  dns_name = each.value.dns_name
  visibility = each.value.visibility
  description = coalesce(each.value.description, "Managed zone for ${each.value.name}")

  dynamic "private_visibility_config" {
    for_each = each.value.visibility == "private" ? [1] : []
    content {
      networks {
        network_url = "https://www.googleapis.com/compute/v1/projects/cloit-host-dev/global/networks/cloit-d-host-vpc"
      }
    }
  }

}

resource "google_dns_record_set" "record_set" {
  for_each = { for rec in local.flattened_records : "${rec.zone_name}-${rec.record_name}-${rec.type}" => rec }

  name         = each.value.record_name
  type         = each.value.type
  ttl          = each.value.ttl
  managed_zone = google_dns_managed_zone.zone[each.value.zone_name].name
  rrdatas      = each.value.rrdata
}
