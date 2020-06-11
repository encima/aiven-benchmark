# Aiven Kafka benchmark

## Summary

This repository contains the tools for running Kafka benchmarks against Aiven Kafka services.

The first iteration is a pure write throughput test. We'll add functionality for read/write test in the upcoming iterations.

There are three tools:

    load_generate    A dockerized tool for generating write load

    results_reader   A tool for polling the system under test for performance numbers

    load_reader      A dockerized tool for generating read load

## Pre-requisites

- Create a Aiven authentication/API token
- Target Aiven Kafka service with selected plan and cloud region must be up and running
- The Kafka topic used for testing with selected partition count and replication factor must be created beforehand

### Suggested Setup

- Kafka Business/Premium plans
- Influx + Grafana metrics integration for monitoring
- Topic: `load-topic` \
- Partitions: `30` \
- Replication: `3`

## Producer Load generator

### Starting the load generator

You can start a single instance of the load generator with the following command:

```bash
export AVN_TOKEN="TOKEN_DATA"
docker run -e AIVEN_TOKEN=$AVN_TOKEN -e AIVEN_PROJECT="david-demo" -e AIVEN_SERVICE="kafka-bench" -e AIVEN_TOPIC="load-topic" --rm -d davidavn/avn-bench-kafka-load-generator
```

Substitute the placeholder values with your correct token, project, service and the target topic.

Tip: you can use e.g. managed Kubernetes service to scale up number of load generators until you reach the saturation point.

### (Optional) Build local Docker image

    docker build -t avn-bench-kafka-load-generator load_generator

## Result reader

### Build local Docker image

    docker build -t aiven-benchmark-kafka-result-reader result_reader

### Collecting the results

You can start result reader instance with the following command:

    docker run \
        -e AIVEN_TOKEN="TOKENDATA" \
        -e AIVEN_PROJECT="htn-aiven-demo" \
        -e AIVEN_SERVICE="t-kafka" \
        -e AIVEN_TOPIC="t-topic" \
        --rm \
        aiven-benchmark-kafka-result-reader

## Consumer Load generator

### Starting the load generator

You can start a single instance of the load generator with the following command:

```bash
export AVN_TOKEN="TOKEN_DATA"

# optional --e AIVEN_CONSUMER_GROUP="my-consumer-group"
docker run -e AIVEN_TOKEN=$AVN_TOKEN -e AIVEN_PROJECT="david-demo" -e AIVEN_SERVICE="kafka-bench" -e AIVEN_TOPIC="load-topic" --rm -d davidavn/avn-bench-kafka-load-reader
```

Substitute the placeholder values with your correct token, project, service and the target topic.

Tip: you can use e.g. managed Kubernetes service to scale up number of load generators until you reach the saturation point.

### (Optional) Build local Docker image

    docker build -t avn-bench-kafka-load-reader load_reader
