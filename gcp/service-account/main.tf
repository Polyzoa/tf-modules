resource "google_service_account" "sa" {
  account_id   = "${var.sa_account_id}-sa"
  display_name = "${var.sa_account_name} Service Account"
}

resource "google_project_iam_member" "bigquery_user" {
  count   = var.bigquery_user ? 1 : 0
  project = var.project
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "datastore_user" {
  count   = var.datastore_user ? 1 : 0
  project = var.project
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "firestore_service_agent" {
  count   = var.firestore_service_agent ? 1 : 0
  project = var.project
  role    = "roles/firestore.serviceAgent"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "storage_viewer" {
  count   = var.storage_viewer ? 1 : 0
  project = var.project
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "firestore_data_analyst" {
  count   = var.firestore_data_analyst ? 1 : 0
  project = var.project
  role    = "roles/fireAnal"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "api_keys_viewer" {
  count   = var.api_keys_viewer ? 1 : 0
  project = var.project
  role    = "roles/serviceusage.apiKeysViewer"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "api_keys_creator" {
  count   = var.api_keys_creator ? 1 : 0
  project = var.project
  role    = "projects/blockchain-plz-mlr/roles/ApiKeyCreator"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "api_monitoring" {
  count   = var.api_monitoring ? 1 : 0
  project = var.project
  role    = "projects/blockchain-plz-mlr/roles/ApiMonitoring"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "aiplatform_admin" {
  count   = var.aiplatform_admin ? 1 : 0
  project = var.project
  role    = "roles/aiplatform.admin"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "pubsub_publisher" {
  count   = var.pubsub_publisher ? 1 : 0
  project = var.project
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

resource "google_project_iam_member" "pubsub_subscriber" {
  count   = var.pubsub_subscriber ? 1 : 0
  project = var.project
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.sa.email}"
}

output "service_account_email" {
  value = google_service_account.sa.email
}
