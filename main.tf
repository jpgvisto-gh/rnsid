provider "google" {
  credentials = file(var.gcp_key)
  project     = var.project_id
  region      = var.region
}

resource "google_sql_database_instance" "default" {
  name = "rnsid-visto-db-instance"
  region = var.region

  database_version = "rnsid-vistoSQL_5_7"
  root_password    = "examplepassword"

  settings {
    tier = "db-f1-micro"
    activation_policy = "ALWAYS"
  }
}

resource "google_sql_database" "default" {
  name     = "rnsid-visto-database"
  instance = google_sql_database_instance.default.name
}

resource "google_cloud_run_service" "default" {
  name     = "rnsid-visto-cloud-run-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/google-samples/hello-app:1.0"
      }
    }
  }

  traffic {
    percent     = 100
    revision_name = google_cloud_run_service.default.latest_revision.name
  }
}

resource "google_compute_backend_service" "default" {
  name        = "rnsid-visto-backend-service"
  protocol    = "HTTP"
  port_name   = "http"
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}

resource "google_compute_url_map" "default" {
  name            = "rnsid-visto-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "http-forwarding-rule"
  target                = google_compute_target_http_proxy.default.id
  port_range            = "80"
  ip_address            = google_compute_global_address.default.address
}

resource "google_compute_global_address" "default" {
  name = "http-address"
}
