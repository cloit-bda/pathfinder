# cloit-d-ingest-ce-gateway-an3a-001
variable "network" {}
variable "network_name" {}
variable "subnet" {}
variable "subnet_name" {}
variable "region" {}
variable "zone" {}
variable "pre_fix" {}
variable "ingest_project" {}
variable "data_project" {}
variable "project_name" {}
variable "host_project" {}
variable "machine_spec" {}
variable "boot_disk_size" {}
variable "boot_disk_image" {}
variable "boot_disk_type" {}
variable "ssh_keys" {}
variable "startup_script_2022" {}
variable "startup_script_20022" {}

# cloit-d-ingest-ce-gateway-an3a-001
resource "google_compute_address" "ingest-eip-gateway-an3" {
  name         = "${var.pre_fix}ingest-eip-gateway-an3"
  address_type = "EXTERNAL"
  region       = var.region
  address      = ""
 project      = var.ingest_project
#   project      = var.host_project
}

resource "google_service_account" "gateway_service_account" {
  account_id   = "${var.pre_fix}ingest-gsa-gw-common"
  display_name = "${var.pre_fix}ingest-gsa-gw-common"
 project      = var.ingest_project
}

resource "google_project_iam_binding" "ingest_log_writer" {
 project = var.ingest_project
#   project      = var.host_project
  role    = "roles/logging.logWriter"
  members = ["serviceAccount:${google_service_account.gateway_service_account.email}","serviceAccount:${google_service_account.cli_service_account.email}",]
  depends_on = [google_service_account.gateway_service_account,google_service_account.cli_service_account]
}

resource "google_project_iam_binding" "ingest_monitoring_metric_writer" {
 project = var.ingest_project
#   project      = var.host_project
  role    = "roles/monitoring.metricWriter"
  members = ["serviceAccount:${google_service_account.gateway_service_account.email}","serviceAccount:${google_service_account.cli_service_account.email}",]
  depends_on = [google_service_account.gateway_service_account,google_service_account.cli_service_account]
}

resource "google_compute_instance" "ingest-ce-gateway-an3a-001" {
  name         = "${var.pre_fix}ingest-ce-gateway-an3a-001"

  machine_type = var.machine_spec
  zone         = var.zone

 project = var.ingest_project
#   project      = var.host_project

  tags = ["${var.pre_fix}net-gateway-common"]
  labels = {
    sec_assets_gateway = "${var.project_name}_system"
  }

  boot_disk {
    auto_delete = "true"
    device_name = "${var.pre_fix}ingest-ce-gateway-an3a-001"
    initialize_params {
      size = var.boot_disk_size
      image = var.boot_disk_image
      type = var.boot_disk_type
    }
  }

  metadata_startup_script = var.startup_script_2022
  metadata = {
    ssh-keys = var.ssh_keys
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.gateway_service_account.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network     = var.network
    subnetwork  = var.subnet

    access_config {
      nat_ip = google_compute_address.ingest-eip-gateway-an3.address
    }
  }
}

# cloit-d-ingest-ce-db-gateway-an3a-001
resource "google_compute_address" "db-gateway" {
  name         = "${var.pre_fix}ingest-eip-db-gateway-an3"
  address_type = "EXTERNAL"
  region       = var.region
  address      = ""
 project      = var.ingest_project
#   project      = var.host_project

}

resource "google_compute_instance" "ingest-ce-db-gateway-an3a-001" {
  name         = "${var.pre_fix}ingest-ce-db-gateway-an3a-001"
  machine_type = var.machine_spec
  zone         = var.zone

  project = var.ingest_project

  tags = ["${var.pre_fix}net-db-gateway-common"]
  labels = {
    sec_assets_gateway = "${var.project_name}_system"
  }

  boot_disk {
    auto_delete = "true"
    device_name = "${var.pre_fix}ingest-ce-db-gateway-an3a-001"
    initialize_params {
      size = var.boot_disk_size
      image = var.boot_disk_image
      type = var.boot_disk_type
    }
  }

  metadata_startup_script = var.startup_script_2022
  metadata = {
    ssh-keys = var.ssh_keys
    #startup-script-url = gs://terraform_test_gm/startup-script
  }

  service_account {

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.gateway_service_account.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network     = var.network
    subnetwork  = var.subnet

    access_config {
      nat_ip = google_compute_address.db-gateway.address
    }
  }
}


# cloit-d-ingest-ce-cli-an3a-001
resource "google_service_account" "cli_service_account" {
  account_id   = "${var.pre_fix}ingest-gsa-cli-common"
  display_name = "${var.pre_fix}ingest-gsa-cli-common"
 project      = var.ingest_project
#   project      = var.host_project
}

resource "google_project_iam_binding" "ingest_service_account_user" {
 project      = var.ingest_project
#   project      = var.host_project
  role    = "roles/iam.serviceAccountUser"
  members = ["serviceAccount:${google_service_account.cli_service_account.email}"]
  depends_on = [google_service_account.cli_service_account]
}

resource "google_project_iam_binding" "ingest_k8s_cluster_viewer" {
 project      = var.ingest_project
#   project      = var.host_project
  role    = "roles/container.clusterViewer"
  members = ["serviceAccount:${google_service_account.cli_service_account.email}"]
  depends_on = [google_service_account.cli_service_account]
}

resource "google_project_iam_binding" "ingest_k8s_cluster_admin" {
#  project = "beha-data"
 project      = var.data_project
#   project      = var.host_project
  role    = "roles/container.clusterAdmin"
  members = ["serviceAccount:${google_service_account.cli_service_account.email}"]
  depends_on = [google_service_account.cli_service_account]
}


resource "google_compute_address" "cli" {
  name = "${var.pre_fix}ingest-ip-cli-an3"
  subnetwork   = var.subnet
  address_type = "INTERNAL"
  address      = "172.30.0.11" #
  region       = var.region
#  project      = var.ingest_project
  project      = var.host_project

}

resource "google_compute_instance" "ingest-ce-cli-an3a-001" {
  name         = "${var.pre_fix}ingest-ce-cli-an3a-001"
  machine_type = var.machine_spec
  zone         = var.zone

#  project = var.ingest_project
  project      = var.host_project

  tags = ["${var.pre_fix}net-ce-common"]
  labels = {
    sec_assets_gateway = "${var.project_name}_system"
  }

  boot_disk {
    auto_delete = "true"
    device_name = "${var.pre_fix}ingest-ce-cli-an3a-001"
    initialize_params {
      size = var.boot_disk_size
      image = var.boot_disk_image
      type = var.boot_disk_type
    }
  }

  metadata_startup_script = var.startup_script_20022
  metadata = {
    ssh-keys = var.ssh_keys
    #startup-script-url = gs://terraform_test_gm/startup-script
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.cli_service_account.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnet
    subnetwork_project = var.host_project
    network_ip         = google_compute_address.cli.address
  }
}
#cloit-d-ingest-ce-db-cli-an3a-001
resource "google_compute_address" "db-cli" {
  name = "${var.pre_fix}ingest-ip-db-cli-an3"
  subnetwork         = var.subnet
  address_type = "INTERNAL"
  address      = "172.30.0.21"
  region       = var.region
  project      = var.ingest_project
#   project      = var.host_project

}

resource "google_compute_instance" "ingest-ce-db-cli-an3a-001" {
  name         = "${var.pre_fix}ingest-ce-db-cli-an3a-001"
  machine_type = var.machine_spec
  zone         = var.zone

  project = var.ingest_project

#   project      = var.host_project

  tags = ["${var.pre_fix}net-ce-db-cli"]
  labels = {
    sec_assets_gateway = "${var.project_name}_system"
  }

  boot_disk {
    auto_delete = "true"
    device_name = "${var.pre_fix}ingest-ce-db-cli-an3a-001"
    initialize_params {
      size = var.boot_disk_size
      image = var.boot_disk_image
      type = var.boot_disk_type
    }
  }

  metadata_startup_script = var.startup_script_20022
  metadata = {
    ssh-keys = var.ssh_keys
    #startup-script-url = gs://terraform_test_gm/startup-script
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.cli_service_account.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network            = var.network
    subnetwork         = var.subnet
    subnetwork_project = var.host_project
    network_ip         = google_compute_address.db-cli.address
  }
}