module "vpc" {
  source     = "../../../modules/network/vpc"
  project_id = var.project_id

  for_each = { for v in local.vpc_data : v.name => v }

  network_name = each.value.name
  mtu          = each.value.mtu
  routing_mode = each.value.routing_mode
}

