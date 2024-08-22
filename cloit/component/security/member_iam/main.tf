variable "path" {}
variable "project_id" {}

locals {
  raw_iam_data = try(file(var.path), "")
  iam_data   = yamldecode(file(var.path))

  # Extract distinct service accounts and groups from the YAML data
  service_accounts_roles_map = { for binding in local.iam_data : binding.members => binding.role }

  # Split member into prefix and address
  split_members = { for member, roles in local.service_accounts_roles_map :
    member => {
      prefix = split(":", member)[0],  # e.g., "serviceAccount" or "group"
      address = split(":", member)[1], # e.g., "507714094898@cloudbuild.gserviceaccount.com"
      roles = roles
    }
  }
}


module "member_roles" {
  for_each = local.split_members

  source                  = "../../../modules/iam/member_iam"
  service_account_address = each.value.address # "507714094898@cloudbuild.gserviceaccount.com"
  prefix                  = each.value.prefix  # "serviceAccount" or "group"
  project_id              = var.project_id
  project_roles           = each.value.roles
}

