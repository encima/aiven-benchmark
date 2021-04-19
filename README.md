# Aiven Benchmark Tools

This repository contains tooling for benchmarking Aiven service performance.

## Providers

1. Aiven
2. Elastic.co
3. AWS

## Modules

1. [Community AWS Elasticsearch](https://github.com/terraform-community-modules/tf_aws_elasticsearch.git?ref=v1.1.0)
## Authentication

### Aiven

### Elastic.co

https://cloud.elastic.co/deployment-features/keys

### AWS

## Benchmarking

### Installing ESRally

`pip3 install esrally`

### Running a Benchmark on a Remote Cluster

```
esrally race --track=<TRACK> --target-hosts=<HOST>:<PORT> --client-options="timeout:60,use_ssl:true,verify_certs:true,basic_auth_user:'<USER>',basic_auth_password:'<PASS>'"  --pipeline=benchmark-only --kill-running-processes
```

