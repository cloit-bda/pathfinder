module "firewall_rules" {
  source       = "../../../modules/network/firewall-rules"
  project_id   = local.project_id
  network_name = var.vpc

  rules = [for r in local.rules_data :
    merge({
      name                    = r.name
      description             = lookup(r, "description", null)
      direction               = r.direction
      priority                = r.priority
      ranges                  = lookup(r, "sourceRanges", null)
      source_tags             = lookup(r, "sourceTags", null)
      source_service_accounts = lookup(r, "source_service_accounts", null)
      target_tags             = lookup(r, "targetTags", null)
      target_service_accounts = lookup(r, "target_service_accounts", null)
      log_config              = lookup(r, "log_config", null)
    },
      contains(keys(r), "allow") ? {
        allow = [
          for entry in r.allow : {
            protocol = keys(entry)[0]
            ports    = entry[keys(entry)[0]] != null ? [for port in entry[keys(entry)[0]] : tostring(port)] : []
          }
        ]
      } : { allow = [] },
      contains(keys(r), "deny") ? {
        deny = [
          for entry in r.deny : {
            protocol = keys(entry)[0]
            ports    = entry[keys(entry)[0]]
          }
        ]
      } : { deny = [] }
    )]
}
