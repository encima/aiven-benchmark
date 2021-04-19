provider "aiven" {
  api_token = var.aiven_api_token
}

resource "aiven_elasticsearch" "es1" {
    project = var.aiven_project
    cloud_name = "aws-eu-west-4"
    plan = "startup-4"
    service_name = "my-es1"
    maintenance_window_dow = "monday"
    maintenance_window_time = "10:00:00"

    elasticsearch_user_config {
        elasticsearch_version = 7

        kibana {
            enabled = true
            elasticsearch_request_timeout = 30000
        }

        public_access {
            elasticsearch = true
            kibana = true
        }
    }
}

// output "elasticsearch_https_endpoint" { 
//   value = ec_deployment.ci-deployment.elasticsearch[0].https_endpoint 
// } 
// output "aiven_es_password" { 
//   value = ec_deployment.ci-deployment.elasticsearch_password 
// }

// data "template_file" "aiven_es_configuration" { 
//   template   = file("configs/aiven_es_config.sh") 
//   depends_on = [ec_deployment.ci-deployment] 
//   vars = { 
//     # Created servers and appropriate AZs 
//     elastic-user     = ec_deployment.ci-deployment.elasticsearch_username 
//     elastic-password = ec_deployment.ci-deployment.elasticsearch_password 
//     es-url           = ec_deployment.ci-deployment.elasticsearch[0].https_endpoint 
//   } 
// }


// resource "null_resource" "bootstrap-elasticsearch" { 
//   provisioner "local-exec" { 
//     command = data.template_file.elasticsearch-configuration.rendered 
//   } 
// } 
