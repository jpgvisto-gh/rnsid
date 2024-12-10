variable "project_id" {}
variable "region" {
  default = "us-east1"
}
variable "zone" {
  default = "us-east1-a"
}

variable "gcp_key" {
  default = "$HOME/gcp-key.json"
}