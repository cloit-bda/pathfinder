variable "path" {}

module "subnetwork" {
  source       = "../../../modules/network/subnets"

  project_id =  var.project_id
  network_name = var.vpc


  subnets = [for s in local.subnets_data : {
    subnet_name   = s.name
    subnet_ip     = s.range
    subnet_region = s.region
    subnet_private_access = s.subnet_private_access
    description   = s.description
  }]

  secondary_ranges = {for s in local.subnets_data : s.name => [for sr in lookup(s, "secondary_ranges", []) : {
    range_name    = sr.rangeName
    ip_cidr_range = sr.ipCidrRange
  }] if lookup(s, "secondary_ranges", null) != null}
}
