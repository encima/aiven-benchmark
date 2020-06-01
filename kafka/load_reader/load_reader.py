from aiven.client import AivenClient
from kafka.consumer import KafkaConsumer
from kafka.structs import TopicPartition

import json
import logging
import os
import time


def main():
    logger = logging.getLogger(os.path.basename(__file__))

    # Setup Aiven SDK
    logger.info("Setting up Aiven SDK")
    client = AivenClient("https://api.aiven.io")
    client.set_auth_token(os.environ["AIVEN_TOKEN"])

    # Lookup the target service
    logger.info("Looking up the target Aiven Kafka Service")
    service = client.get_service(
        project=os.environ["AIVEN_PROJECT"], service=os.environ["AIVEN_SERVICE"])
    if not service:
        raise SystemExit("Failed to look up the target service")

    # Store credentials on disk. This is using the main access certificates (avnadmin).
    logger.info("Storing Aiven service access credentials")
    with open("client.crt", "w") as fh:
        fh.write(service["connection_info"]["kafka_access_cert"])
    with open("client.key", "w") as fh:
        fh.write(service["connection_info"]["kafka_access_key"])

    # Project CA certificate
    logger.info("Fetching project CA certificate")
    result = client.get_project_ca(project=os.environ["AIVEN_PROJECT"])
    with open("ca.crt", "w") as fh:
        fh.write(result["certificate"])

    # Initialize Kafka client
    consumer = KafkaConsumer(
        os.environ["AIVEN_TOPIC"],
        auto_offset_reset="latest",
        bootstrap_servers=service["service_uri"],
        client_id="avn-load-client",
        group_id="anv-load-001",
        security_protocol="SSL",
        ssl_cafile="ca.crt",
        ssl_certfile="client.crt",
        ssl_keyfile="client.key",
    )

    while True:
        raw_msgs = consumer.poll()
        raw_msgs.items()
        consumer.commit()


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()
