variable "cf_config" {
  type = object({
    storage_bucket_name = string
    storage_location    = string
    sa_account_id       = string
    sa_display_name     = string
    name                = string
    description         = string
    location            = string
    runtime             = string
    entry_point         = string
    source_dir          = string
    source_prefix       = string
    service_config      = object({
      max_instance_count                = number
      available_memory                  = string
      timeout_seconds                   = number
      available_cpu                     = number
      ingress_settings                  = string
      all_traffic_on_latest_revision    = bool
      max_instance_request_concurrency  = number
      environment_variables             = map(any)
    })
  })
}
