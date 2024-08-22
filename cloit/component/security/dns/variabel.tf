locals {
  dns_data = yamldecode(file(var.path))
  flattened_records = flatten([
    for zone in local.dns_data.managed_zones : [
      for record in zone.record_sets : {
        zone_name   = zone.name,
        record_name = record.name,
        type        = record.type,
        ttl         = record.ttl,
        rrdata = flatten([record.rrdata])
      }
    ]
  ])
}

variable "path" {}