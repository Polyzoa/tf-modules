locals {
  service_config  = var.cf_config["service_config"]
  obj_name        = var.cf_config["source_prefix"]
  zip_hash        = data.archive_file.cf.output_md5
}

data "archive_file" "cf" {
  type        = "zip"
  output_path = "./${var.cf_config["name"]}.zip"
  source_dir  = var.cf_config["source_dir"]
}

resource "google_storage_bucket" "cf" {
  name          = var.cf_config["storage_bucket_name"]
  location      = var.cf_config["storage_location"]
  force_destroy = false

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

resource "google_storage_bucket_object" "cf" {
  name   = "${local.obj_name}-${local.zip_hash}.zip"
  bucket = google_storage_bucket.cf.name
  source = data.archive_file.cf.output_path
}

resource "google_service_account" "cf" {
  account_id   = var.cf_config["sa_account_id"]
  display_name = var.cf_config["sa_display_name"]
}

resource "google_storage_bucket_iam_member" "cf" {
  bucket  = google_storage_bucket.cf.name
  role    = "roles/storage.admin"
  member  = google_service_account.cf.member
}

resource "google_cloudfunctions2_function" "cf" {
  name        = var.cf_config["name"]
  description = var.cf_config["description"]
  location    = var.cf_config["location"]

  build_config {
    runtime     = var.cf_config["runtime"]
    entry_point = var.cf_config["entry_point"]
    source {
      storage_source {
        bucket = google_storage_bucket.cf.name
        object = google_storage_bucket_object.cf.name
      }
    }
  }

  service_config {
    service_account_email             = google_service_account.cf.email
    max_instance_count                = local.service_config["max_instance_count"]
    available_memory                  = local.service_config["available_memory"]
    timeout_seconds                   = local.service_config["timeout_seconds"]
    max_instance_request_concurrency  = local.service_config["max_instance_request_concurrency"]
    available_cpu                     = local.service_config["available_cpu"]
    ingress_settings                  = local.service_config["ingress_settings"]
    all_traffic_on_latest_revision    = local.service_config["all_traffic_on_latest_revision"]
    environment_variables             = local.service_config["environment_variables"]
  }
}

output "function_uri" {
  value = google_cloudfunctions2_function.cf.service_config[0].uri
}
output "sa_email" {
  value = google_service_account.cf.email
}
