terraform {
  required_providers {
    aiven = {
      source = "aiven/aiven"
      version = "2.1.11"
    }
       ec = {
      source  = "elastic/ec"
      version = "0.1.0-beta"
    }
        aws = {
      source = "hashicorp/aws"
      version = "3.35.0"
    }
  }
}