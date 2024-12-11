terraform {
  backend "gcs" {
    bucket = "rnsid-visto-backend-terraform"
    prefix = "terraform/state"
  }
}
