from aiven.client import AivenClient

import json
import logging
import os
import subprocess
import random
import string

rdkafka_props_template = """\
metadata.broker.list={aiven_service_uri}
security.protocol=ssl
ssl.key.location=client.key
ssl.certificate.location=client.crt
ssl.ca.location=ca.crt
request.timeout.ms=60000
"""


def randomString(stringLength=8):
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))


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

    # write out properties for rdkafka benchmark tool
    logger.info("Create properties file for rdkafka_performance")
    with open("consumer.properties", "w") as fh:
        fh.write(rdkafka_props_template.format(
            aiven_service_uri=service["service_uri"]))

    # Select consumer group
    consumer_group = os.environ["AIVEN_CONSUMER_GROUP"]
    consumer_group = consumer_group if consumer_group else randomString()

    # Start rdkafka_performance tool
    logger.info("Start load generation, break with CTRL-C")
    subprocess.run([
        "/root/librdkafka/examples/rdkafka_performance",
        "-X", "file=consumer.properties",
        "-C",
        "-G", os.environ["AIVEN_CONSUMER_GROUP"],
        "-t", os.environ["AIVEN_TOPIC"],
    ])


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    main()
