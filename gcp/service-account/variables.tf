variable "project" {}
variable "sa_account_id" {}
variable "sa_account_name" {}

variable "bigquery_user" {
  default = false
}
variable "datastore_user" {
  default = false
}
variable "storage_viewer" {
  default = false
}
variable "api_keys_viewer" {
  default = false
}
variable "api_keys_creator" {
  default = false
}
variable "api_monitoring" {
  default = false
}
variable "aiplatform_admin" {
  default = false
}
variable "pubsub_publisher" {
  default = false
}
variable "pubsub_subscriber" {
  default = false
}
variable "firestore_service_agent" {
  default = false
}

variable "firestore_data_analyst" {
  default = false
}
