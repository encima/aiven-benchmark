provider "ec" { 
  apikey = var.ec_api_key 
}

resource "ec_deployment" "ci-deployment" {
  name               = "ci-deployment"
  region                 = "us-east-1"
  version                = "7.10.0"
  deployment_template_id = "aws-io-optimized"
  elasticsearch {}
  kibana {}
}

output "elasticsearch_https_endpoint" { 
  value = ec_deployment.ci-deployment.elasticsearch[0].https_endpoint 
} 
output "elasticsearch_password" { 
  value = ec_deployment.ci-deployment.elasticsearch_password 
}

data "template_file" "elasticsearch-configuration" { 
  template   = file("configs/elastic_es_config.sh") 
  depends_on = [ec_deployment.ci-deployment] 
  vars = { 
    # Created servers and appropriate AZs 
    elastic-user     = ec_deployment.ci-deployment.elasticsearch_username 
    elastic-password = ec_deployment.ci-deployment.elasticsearch_password 
    es-url           = ec_deployment.ci-deployment.elasticsearch[0].https_endpoint 
  } 
}


resource "null_resource" "bootstrap-elasticsearch" { 
  provisioner "local-exec" { 
    command = data.template_file.elasticsearch-configuration.rendered 
  } 
} 
