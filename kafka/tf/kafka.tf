// 
// VARIABLES
// 
variable "kafka_cloud_region" {
    default = "aws-us-east-1"
}

//
// KAFKA - kafka-bench
//
resource "aiven_service" "kafka-bench" {
  project = aiven_project.prj.project
  cloud_name = var.kafka_cloud_region
  plan = "business-4"
  service_name = "kafka-bench"
  service_type = "kafka"
  maintenance_window_dow = "monday"
  maintenance_window_time = "10:00:00"
  kafka_user_config {
    // Enables Kafka Schemas
    kafka_version = "2.5"
  }
}
resource "aiven_kafka_topic" "kafka-bench-topic" {
  project = aiven_project.prj.project
  service_name = aiven_service.kafka-bench.service_name
  topic_name = "load-topic"
  partitions = 30
  replication = 3
  retention_hours = 1
  retention_bytes = 322122547200 # 300GB
}
resource "aiven_service_integration" "kafka-bench-metrics" {
	project = aiven_project.prj.project
	integration_type = "metrics"
	source_service_name = aiven_service.kafka-bench.service_name
	destination_service_name = aiven_service.influx.service_name
}

# //
# // KAFKA - Business 4
# //
# resource "aiven_service" "b4" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "business-4"
#   service_name = "b4"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "b4-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.b4.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "b4-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.b4.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Business 8
# //
# resource "aiven_service" "b8" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "business-8"
#   service_name = "b8"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "b8-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.b8.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "b8-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.b8.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Business 16
# //
# resource "aiven_service" "b16" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "business-16"
#   service_name = "b16"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "b16-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.b16.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "b16-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.b16.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Business 32
# //
# resource "aiven_service" "b32" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "business-32"
#   service_name = "b32"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "b32-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.b32.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "b32-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.b32.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Premium 6x8
# //
# resource "aiven_service" "p6x8" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "premium-6x-8"
#   service_name = "p6x8"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "p6x8-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.p6x8.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "p6x8-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.p6x8.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Premium 6x16
# //
# resource "aiven_service" "p6x16" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "premium-6x-16"
#   service_name = "p6x16"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "p6x16-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.p6x16.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "p6x16-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.p6x16.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Premium 9x8
# //
# resource "aiven_service" "p9x8" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "premium-9x-8"
#   service_name = "p9x8"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "p9x8-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.p9x8.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "p9x8-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.p9x8.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }

# //
# // KAFKA - Premium 9x16
# //
# resource "aiven_service" "p9x16" {
#   project = aiven_project.prj.project
#   cloud_name = var.kafka_cloud_region
#   plan = "premium-9x-16"
#   service_name = "p9x16"
#   service_type = "kafka"
#   maintenance_window_dow = "monday"
#   maintenance_window_time = "10:00:00"
#   kafka_user_config {
#     // Enables Kafka Schemas
#     kafka_version = "2.5"
#   }
# }
# resource "aiven_kafka_topic" "p9x16-topic" {
#   project = aiven_project.prj.project
#   service_name = aiven_service.p9x16.service_name
#   topic_name = "load-topic"
#   partitions = 30
#   replication = 3
#   retention_hours = 1
#   retention_bytes = 322122547200 # 300GB
# }
# resource "aiven_service_integration" "p9x16-metrics" {
# 	project = aiven_project.prj.project
# 	integration_type = "metrics"
# 	source_service_name = aiven_service.p9x16.service_name
# 	destination_service_name = aiven_service.influx.service_name
# }