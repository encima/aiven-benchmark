# Setup

## Files

| Filename                    | Description                                                            |
| --------------------------- | ---------------------------------------------------------------------- |
| `project-base.tf`           | Setup project and monitoring.                                          |
| `variables.tfvars.template` | Template for providing variables.                                      |
| `kafka.tf`                  | Create Kafka cluster(s) and topics, then hook up metrics integrations. |
| `plan.sh`                   | Utility for planning and specifying tf var file.                       |
| `apply.sh`                  | Utility for applying and specifying tf var file.                       |

## Step 0: Setup Terraform + Aiven Provider

Follow [installation instructions](https://github.com/aiven/terraform-provider-aiven#installation).
Note, you should use Terraform version `0.12.\*`.

## Step 1: Initialize Variables

Copy the `variables.tfvars.template` file to `secret.tfvars` and set
the values.

```sh
$ cd kafka/tf
$ cp variables.tfvars.template secret.tfvars
```

## Step 2: Import Project

```sh
$ terraform --version
Terraform v0.12.24
+ provider.aiven (unversioned)

Your version of Terraform is out of date! The latest version
is 0.12.26. You can update by downloading from https://www.terraform.io/downloads.html

$ terraform init
$ terraform import --var-file=<my-vars.tfvars> aiven_project.prj <my-project>
# terraform import --var-file=<my-vars.tfvars> aiven_service.influx <my-project>/<my-influx>
```

## Step 3: Plan / Apply

You can type everything out or use my lazy scripts for plan/apply.

```sh
# The following assumes that you have your variables set in secret.tfvars
# Otherwise use `$ ./plan.sh my-variables.tfvars`
$ ./plan.sh

# The following assumes that you have your variables set in secret.tfvars
# Otherwise use `$ ./apply.sh my-variables.tfvars`
$ ./apply.sh
# confirm by typing `yes`
```
