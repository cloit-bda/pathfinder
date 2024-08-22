variable "path" {
  default = ""
}

locals {
  raw_service_data = split("---", file(var.path))
#  service_data_list = [for data in local.raw_service_data : yamldecode(data) if data != "" && trimspace(data) != ""]
  service_data_list = [for data in local.raw_service_data : yamldecode(data) if data != "" && trimspace(data) != "" && can(yamldecode(data))]
  service_accounts = [for sa in flatten(local.service_data_list) : {
#    accountId = element(split("@", sa.email), 0)
    accountId = sa.accountId
    displayName = sa.displayName
    description = sa.description
    projectId   = sa.projectId
  }]
}

resource "google_service_account" "service_account" {
  for_each     = { for sa in local.service_accounts : sa.accountId => sa }
  account_id   = each.value.accountId
  display_name = each.value.displayName
  description  = each.value.description
  project      = each.value.projectId
}
