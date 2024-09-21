resource "google_redis_instance" "redis" {
  name           = var.service_name
  tier           = "BASIC"
  memory_size_gb = 2
  region         = var.location
  redis_version  = "REDIS_6_X"
}

output "host" {
  value = google_redis_instance.redis.host
}

output "port" {
  value = google_redis_instance.redis.port
}


