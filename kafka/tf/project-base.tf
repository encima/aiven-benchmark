// 
// VARIABLES
// 
variable "aiven_api_token" {}
variable "aiven_card_id" {}
variable "project_name" {}
variable "project_account_id" {}

//
// AIVEN SETUP
//
provider "aiven" {
    api_token = var.aiven_api_token
}

resource "aiven_project" "prj" {
  project = var.project_name
  account_id = var.project_account_id
  card_id = var.aiven_card_id
}

//
// METRICS
//
resource "aiven_service" "influx" {
	project = aiven_project.prj.project
	cloud_name = "google-us-east1"
	plan = "startup-4"
	service_name = "bench-metrics"
	service_type = "influxdb"
	maintenance_window_dow = "monday"
	maintenance_window_time = "11:00:00"
	influxdb_user_config {
		ip_filter = ["0.0.0.0/0"]
	}
}

# Grafana Dashboards
resource "aiven_service_integration" "grafana-dashboards" {
	project = aiven_project.prj.project
	integration_type = "dashboard"
	source_service_name = aiven_service.grafana.service_name
	destination_service_name = aiven_service.influx.service_name
}

# Grafana service
resource "aiven_service" "grafana" {
	project = aiven_project.prj.project
	cloud_name = "google-us-east1"
	plan = "startup-1"
	service_name = "bench-grafana"
	service_type = "grafana"
	grafana_user_config {
		ip_filter = ["0.0.0.0/0"]
	}
}