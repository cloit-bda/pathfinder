variable "path" {}
variable "project_id" {}
variable "vpc" {}
locals {
  yaml_content = file(var.path)
  vpc_data   = yamldecode(local.yaml_content)
  project_id   = var.project_id
}