variable "project_id" {
  description = "The ID of the GCP project"
  default     = "modified-antler-444315-k7"
  type        = string
}
variable "region" {
  default = "us-east1"
}
variable "zone" {
  default = "us-east1-a"
}