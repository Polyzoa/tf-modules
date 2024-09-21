module "service-account" {
  source                  = "../service-account"
  project                 = var.project
  sa_account_id           = "polyzoa-${var.service_name}"
  sa_account_name         = "Polyzoa ${var.service_name}"
  api_monitoring          = true
  bigquery_user           = true
  api_keys_viewer         = true
  api_keys_creator        = true
  aiplatform_admin        = true
  datastore_user          = true
  pubsub_publisher        = true
  pubsub_subscriber       = true
  firestore_service_agent = true
}

resource "google_cloud_run_service" "service-api" {
  location = var.location
  name     = var.service_name

  metadata {
    annotations = {
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }

  template {
    spec {
      service_account_name  = module.service-account.service_account_email
      container_concurrency = 80
      containers {
        image = "europe-west3-docker.pkg.dev/blockchain-plz-mlr/polyzoa/${var.container_name}:latest"
        ports {
          container_port = 8081
        }
        resources {
          limits = {
            cpu    = var.cpu_limit,
            memory = var.memory_limit
          }
        }
        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.key
            value = env.value
          }
        }
      }
    }
    metadata {
      labels = {
        name = "polyzoa-${var.container_name}"
        type = "rpc"
      }
      annotations = {
        "autoscaling.knative.dev/maxScale"         = var.max_scale,
        "autoscaling.knative.dev/minScale"         = var.min_scale,
        "run.googleapis.com/cpu-throttling"        = var.cpu_throttling,
        "run.googleapis.com/startup-cpu-boost"     = true,
        "run.googleapis.com/execution-environment" = var.execution_environment
        "run.googleapis.com/network-interfaces"    = "[{'network':'default','subnetwork':'default'}]"
      }
    }
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = var.location
  project  = var.project
  service  = google_cloud_run_service.service-api.name

  policy_data = var.policy_data
}


output "name" {
  value = google_cloud_run_service.service-api.name
}

output "service_url" {
  value = google_cloud_run_service.service-api.status[0].url
}