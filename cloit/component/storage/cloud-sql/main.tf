variable "path" {}

locals {
  # Decode the YAML file and split into individual documents
  sql_data_raw = [for doc in split("---", file(var.path)) : yamldecode(doc) if doc != ""]

  # Extract the necessary information for each instance
  instances = [for instance in local.sql_data_raw : {
    name         = instance["name"],
    project      = instance["project"],
    region       = instance["region"],
    zone         = instance["gceZone"],
    machine_type = instance["settings"]["tier"],
    database_version = instance["databaseVersion"]
  }]
}

# Cloud SQL Resource
resource "google_sql_database_instance" "instance" {
  for_each = { for instance in local.instances : instance.name => instance }

  name             = each.value.name
  project          = each.value.project
  region           = each.value.region
  database_version = each.value.database_version

  settings {
    tier = each.value.machine_type
  }
}

# Output
output "instances_output" {
  value       = google_sql_database_instance.instance
  description = "Details of the created Cloud SQL instances"
}