terraform {
  backend "gcs" {
    bucket = "rnsid-visto-backend-terraform"
    prefix = "terraform/state"
  }
  required_providers {
        google = {
            version = "~> 4.83.0"
        }
        google-beta = {
            version = "~> 4.83.0"
        }
    }
}
