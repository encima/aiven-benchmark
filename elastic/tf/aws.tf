provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}


module "es" {
  source  = "git::https://github.com/terraform-community-modules/tf_aws_elasticsearch.git?ref=v1.1.0"

  domain_name                    = "my-elasticsearch-domain"
  management_public_ip_addresses = ["34.203.XXX.YYY"]
  instance_count                 = 4
  instance_type                  = "i3.large.elasticsearch"
  dedicated_master_type          = false
  es_zone_awareness              = true
  ebs_volume_size                = 10
}

// resource "aws_elasticsearch_domain" "example" {
//   domain_name           = "example"
//   elasticsearch_version = "1.7"

//   cluster_config {
//     instance_type = "r4.large.elasticsearch"
//   }

//   snapshot_options {
//     automated_snapshot_start_hour = 23
//   }

//     access_policies = <<CONFIG
// {
//     "Version": "2012-10-17",
//     "Statement": [
//         {
//             "Action": "es:*",
//             "Principal": "*",
//             "Effect": "Allow",
//             "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"
//         }
//     ]
// }
// CONFIG

//   tags = {
//     Domain = "TestDomain"
//   }
// }


// data "template_file" "elasticsearch-configuration" { 
//   template   = file("configs/aws_es_config.sh") 
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
