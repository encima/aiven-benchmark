#!/bin/bash

terraform apply --var-file=${1:-secret.tfvars}