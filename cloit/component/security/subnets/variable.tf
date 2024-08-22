
locals {
  yaml_content = file(var.path)
#  yaml_content = file("${path.module}/resources/security/subnets.yaml")
  subnets_data = yamldecode(local.yaml_content)
}

variable "vpc" {}
variable "project_id" {}

