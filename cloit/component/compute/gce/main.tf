variable "path" {}
variable "project_id" {}

locals {
  gce_data_raw = [for gce in split("---", file(var.path)) : yamldecode(gce) if gce != ""]
}

resource "google_compute_instance" "instance" {
  for_each = {for gce in local.gce_data_raw : gce.name => gce}

  ## 삭제 방지
  deletion_protection = each.value.deletionProtection

  dynamic "attached_disk" {
    for_each = { for disk in each.value.disks : disk.deviceName => disk if !disk.boot }
    content {
      device_name = attached_disk.key
      mode        = attached_disk.value.mode
      source      = attached_disk.value.source
    }
  }

  boot_disk {
    auto_delete = [for disk in each.value.disks : disk.autoDelete if disk.boot][0]
    device_name = [for disk in each.value.disks : disk.deviceName if disk.boot][0]
    mode        = [for disk in each.value.disks : disk.mode if disk.boot][0]
    source      = [for disk in each.value.disks : disk.source if disk.boot][0]
  }

  labels = can(each.value.labels) ? each.value.labels : {}

  machine_type = each.value.machineType

  metadata = {
    for item in each.value.metadata.items : item.key => item.value
  }

  name = each.value.name

  network_interface {
    network    = each.value.networkInterfaces[0].network
    network_ip = each.value.networkInterfaces[0].networkIP
    subnetwork = each.value.networkInterfaces[0].subnetwork

    dynamic "access_config" {
      for_each = can(each.value.networkInterfaces[0].accessConfigs) ? each.value.networkInterfaces[0].accessConfigs : []

      content {
        nat_ip               = access_config.value.natIP
        network_tier         = access_config.value.networkTier
      }
    }
  }
  project = var.project_id # split("/", each.value.selfLink)[6]

  scheduling {
    automatic_restart   = each.value.scheduling.automaticRestart
    on_host_maintenance = each.value.scheduling.onHostMaintenance
    provisioning_model  = each.value.scheduling.provisioningModel
  }

  service_account {
    email  = each.value.serviceAccounts[0].email
    scopes = each.value.serviceAccounts[0].scopes
  }

  shielded_instance_config {
    enable_integrity_monitoring = each.value.shieldedInstanceConfig.enableIntegrityMonitoring
    enable_vtpm                 = each.value.shieldedInstanceConfig.enableVtpm
    enable_secure_boot          = each.value.shieldedInstanceConfig.enableSecureBoot
  }

  tags = each.value.tags.items
  zone = element(split("/", each.value.zone), length(split("/", each.value.zone)) - 1)

  # Ensure Terraform doesn't recreate the resource if the following attributes change
  lifecycle {
    ignore_changes = []
#    ignore_changes = [boot_disk, attached_disk, network_interface, service_account]
  }
}
