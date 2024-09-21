variable "project" {}
variable "location" {}
variable "service_name" {}
variable "container_name" {}
variable "environment_variables" {}
variable "policy_data" {}
variable "cpu_throttling" {
  default = false
}

variable "min_scale" {
  default = 2
}
variable "max_scale" {
  default = 2
}
variable "cpu_limit" {
  default = "2.0"
}
variable "memory_limit" {
  default = "1Gi"
}
variable "execution_environment" {
  default = "gen1"
}
