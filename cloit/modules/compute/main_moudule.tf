module "gce" {
  source               = "_gce"
  ingest_project       = local.ingest_project
  host_project         = local.host_project
  data_project         = local.data_project
  network              = local.network
  network_name         = local.network_name
  region               = local.region
  zone                 = local.zone
  pre_fix              = local.pre_fix
  project_name         = var.project_name
  subnet               = local.subnet
  subnet_name          = local.subnet_name
  boot_disk_size       = var.boot_disk_size
  boot_disk_image      = var.boot_disk_image
  boot_disk_type       = var.boot_disk_type
  machine_spec         = var.machine_spec
  ssh_keys             = var.ssh_keys
  startup_script_2022  = var.startup_script_2022
  startup_script_20022 = var.startup_script_20022
}


module "gke" {
  source                 = "gke"
  ingest_project         = local.ingest_project
  host_project           = local.host_project
  service_project        = local.service_project
  network                = local.network
  network_name           = local.network_name
  subnet_url             = local.subnet_url
  region                 = local.region
  zone_a                 = var.zone_a
  zone_b                 = var.zone_b
  pre_fix                = local.pre_fix
  image_type             = var.image_type
  project_name           = var.project_name
  subnet_name            = local.subnet_name
  boot_disk_size         = var.boot_disk_size
  boot_disk_image        = var.boot_disk_image
  boot_disk_type         = var.boot_disk_type
  machine_spec           = var.machine_spec
  ssh_keys               = var.ssh_keys
  service_project_number = var.service_project_number
  #  depends_on      = [module.gce]
}
