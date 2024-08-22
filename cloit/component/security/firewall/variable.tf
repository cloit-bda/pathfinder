variable "path" {}
variable "project_id" {}
variable "vpc" {}
locals {
  yaml_content = file(var.path)
  rules_data   = yamldecode(local.yaml_content)
  project_id   = "cloit-host-dev"
}