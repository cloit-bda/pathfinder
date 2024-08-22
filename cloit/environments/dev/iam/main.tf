module "iam_member" {
  source     = "../../../component/security/member_iam"
  project_id = var.project_id
  path       = "./resource/${var.project_id}.yaml"
}

