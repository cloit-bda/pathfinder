locals {
  yaml_file = "${path.module}"
}

# Project ID를 받아서 실행 한다.
variable "project_id" {
  type = string
}