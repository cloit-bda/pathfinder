terraform {
  backend "gcs" {
    bucket = "cloit-d-host-cs-terraform-state"
    prefix = "terraform/state/dev/networks"
  }
}
