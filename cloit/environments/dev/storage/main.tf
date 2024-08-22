module "mysql" {
  source     = "../../../component/storage/cloud-sql"
  path       = "resource/sql.yaml"
}
