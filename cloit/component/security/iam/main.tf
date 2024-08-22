variable "path" {
  default = ""
}

locals {
  iam_data_raw = yamldecode(file(var.path))
  bindings = {
    for binding in local.iam_data_raw :
    binding["role"] => binding["members"] if contains(keys(binding), "role") && contains(keys(binding), "members")
  }
}

module "project_iam" {
  source   = "../../../modules/iam/projects_iam"
  projects = ["cloit-host-dev"]
  mode     = "additive"
  bindings = local.bindings
}

output "bindings_output" {
  value = local.iam_data_raw
  description = "Output the bindings local variable"
}

variable "bindings" {
  description = "IAM role bindings"
  type = map(list(string))
  default = {}
}
