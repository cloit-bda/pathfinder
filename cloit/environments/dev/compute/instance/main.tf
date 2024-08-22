variable "project_id" {

}
module "instance" {
  source     = "../../../../component/compute/gce"
  path       = "resource/${var.project_id}.yaml"
  project_id = "${var.project_id}"
}