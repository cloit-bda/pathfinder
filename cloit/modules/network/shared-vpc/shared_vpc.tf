variable "host_project" {}
variable "ingest_project" {}
variable "data_project" {}
variable "service_project" {}

resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project
}

resource "google_compute_shared_vpc_service_project" "ingest" {
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = var.ingest_project
}

# Service Project 설정 : Data Project
resource "google_compute_shared_vpc_service_project" "data" {
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = var.data_project
}

# Service Project 설정 : Data Project
resource "google_compute_shared_vpc_service_project" "service" {
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = var.service_project
}


variable "members" {
  type    = list
  default = [
    "serviceAccount:beha-ingest-compute@developer.gserviceaccount.com",
    "serviceAccount:beha-data-compute@developer.gserviceaccount.com",
    "serviceAccount:beha-data@cloudservices.gserviceaccount.com",
    "serviceAccount:service-beha-data@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:service-beha-data@containerregistry.iam.gserviceaccount.com",
    "serviceAccount:service-beha-data@dataflow-service-producer-prod.iam.gserviceaccount.com",
  ]

}
/*
resource "google_compute_subnetwork_iam_binding" "data1" {
    members    = var.members
    project    ="${var.host_project}"
    region     = "asia-northeast3"
    role       = "roles/compute.networkUser"
    subnetwork = "projects/${var.host_project}/regions/asia-northeast3/subnetworks/beha-p-sub-data-ce-an3"

}

# Data2 Subnet 에 Network User 로 Service Account 추가
# google_compute_subnetwork_iam_binding.editor2:
resource "google_compute_subnetwork_iam_binding" "data2" {
    members    = var.members
    project    ="${var.host_project}"
    region     = "asia-northeast3"
    role       = "roles/compute.networkUser"
    subnetwork = "projects/${var.host_project}/regions/asia-northeast3/subnetworks/beha-p-sub-data-cps01-an3"
 
}

# Ingest Subnet 에 Network User 로 Service Account 추가
# google_compute_subnetwork_iam_binding.editor3:
resource "google_compute_subnetwork_iam_binding" "ingest1" {
#   etag       = "BwWtIqJH_do="
#    id         = "projects/${var.host_project}/regions/asia-northeast3/subnetworks/dqa-${var.branch}-host-sub-ingest-an3-001/roles/compute.networkUser"
    members    = [
        "serviceAccount:${var.ingest_project}-compute@developer.gserviceaccount.com",
        "serviceAccount:${var.ingest_project}@cloudservices.gserviceaccount.com",
        "serviceAccount:service-${var.ingest_project}@container-engine-robot.iam.gserviceaccount.com",
        "serviceAccount:service-${var.ingest_project}@containerregistry.iam.gserviceaccount.com",
    ]
    project    ="${var.host_project}"
    region     = "asia-northeast3"
    role       = "roles/compute.networkUser"
    subnetwork = "projects/${var.host_project}/regions/asia-northeast3/subnetworks/beha-p-sub-ingest-dmz-an3"
}

# Ingest Subnet 에 Network User 로 Service Account 추가
# google_compute_subnetwork_iam_binding.editor4:
resource "google_compute_subnetwork_iam_binding" "ingest2" {
#   etag       = "BwWtIqRJ43Q="
#    id         = "projects/${var.host_project}/regions/asia-northeast3/subnetworks/dqa-${var.branch}-host-sub-ingest-an3-002/roles/compute.networkUser"
    members    = [
        "serviceAccount:${var.ingest_project}-compute@developer.gserviceaccount.com",
        "serviceAccount:${var.ingest_project}@cloudservices.gserviceaccount.com",
        "serviceAccount:service-${var.ingest_project}@container-engine-robot.iam.gserviceaccount.com",
        "serviceAccount:service-${var.ingest_project}@containerregistry.iam.gserviceaccount.com",
    ]
    project    ="${var.host_project}"
    region     = "asia-northeast3"
    role       = "roles/compute.networkUser"
    subnetwork = "projects/${var.host_project}/regions/asia-northeast3/subnetworks/beha-p-sub-ingest-system-an3"
}

# Ingest Subnet 에 Network User 로 Service Account 추가
# google_compute_subnetwork_iam_binding.editor5:
resource "google_compute_subnetwork_iam_binding" "service1" {
  members    = [
        "serviceAccount:devops-terraform@bespin-cloud.site",
        "serviceAccount:759604279953-compute@developer.gserviceaccount.com",
        "serviceAccount:759604279953@cloudservices.gserviceaccount.com",
        "serviceAccount:cloit-d-service-gsa-dive-gke@beha-service.iam.gserviceaccount.com",
    ]
    project    ="${var.host_project}"
    region     = "asia-northeast3"
    role       = "roles/compute.networkUser"
    subnetwork = "beha-p-sub-service-dive01-an3"
}

*/

