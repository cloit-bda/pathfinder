module "service_account" {
  source = "../../../component/security/service_account"
  path   = "resource/serviceaccount.yaml"
}
