

#variable "network" {
#  description = "The name of the network in your project to which the private connection will connect."
#}
#
#variable "service" {
#  description = "The service that will be used for this connection, for example 'servicenetworking.googleapis.com'."
#}
#
variable "path" {}
#
#resource "google_service_networking_connection" "private_connection" {
#  network                 = var.network
#  service                 = var.service
#  reserved_peering_ranges = ["YOUR_RESERVED_PEERING_RANGE_NAME"]
#}
#
#output "private_connection_id" {
#  value = google_service_networking_connection.private_connection.id
#}
#
#
##data "local_file" "yaml_output" {
###  depends_on = [data]
##  filename = "${path.module}/output.txt"
##}
#
#
#locals {
#  data = yamldecode(file(var.path))
#}


locals {
  data = yamldecode(file(var.path))
}

resource "google_service_networking_connection" "private_connection" {
  network                 = local.data.network
  service                 = local.data.service
  reserved_peering_ranges = [local.data.reserved_peering_range_name] # Assuming this value is also in your YAML
}

output "private_connection_id" {
  value = google_service_networking_connection.private_connection.id
}