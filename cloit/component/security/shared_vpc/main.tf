resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project
}

resource "google_compute_shared_vpc_service_project" "service" {
  for_each = local.shared_vpc_projects

  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = each.key
}