module "vpc" {
  source     = "../../../component/security/vpc"
  path       = "./resource/vpc.yaml"
  project_id = local.host_project_id
  vpc        = local.vpc
}

module "subnetwork" {
  source     = "../../../component/security/subnets"
  path       = "./resource/subnets.yaml"
  project_id = local.host_project_id
  vpc        = local.vpc
}

module "firewall" {
  source     = "../../../component/security/firewall"
  path       = "./resource/firewall.yaml"
  project_id = local.host_project_id
  vpc        = local.vpc
}

module "dns" {
  source = "../../../component/security/dns"
  path   = "./resource/dns.yaml"
}

module "shared_vpc" {
  source       = "../../../component/security/shared_vpc"
  path         = "./resource/shared_vpc.yaml"
  host_project = local.host_project_id
}

module "router" {
  source = "../../../component/security/routers"
  path   = "./resource/routers.yaml"
}

module "nat" {
  source = "../../../component/security/nat"
  path   = "./resource/nat.yaml"
}


module "private_connection" {
  source = "../../../component/security/private_connection"
  path   = "./resource/private_connection.yaml"
}

module "static_ip" {
  source = "../../../component/security/google_compute_address"
  path   = "./resource/static_ip.yaml"
}

module "peering" {
  source = "../../../component/security/peering"
  path   = "./resource/static_ip_addresses.yaml"
}

