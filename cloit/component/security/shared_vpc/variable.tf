variable "path" {}
variable "host_project" {}
locals {
  shared_vpc_projects = yamldecode(file(var.path)).shared_vpc_projects
}
