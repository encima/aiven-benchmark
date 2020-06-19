#!/bin/bash

terraform plan --var-file=${1:-secret.tfvars}