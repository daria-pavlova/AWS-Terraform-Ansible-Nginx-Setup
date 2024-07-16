#!/usr/bin/env python

import boto3
import json

# Global variables
INSTANCE_NAME = 'tf-nginx-api-test-vm'
DOMAIN_NAME = 'nginx-api.pp.ua'

def get_instance_by_name(tag_name):
    ec2 = boto3.client('ec2')

    # Describe instances based on tag Name
    response = ec2.describe_instances(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': [tag_name]
            }
        ]
    )

    instances = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            if instance['State']['Name'] == 'running':
                instances.append(instance['PublicDnsName'])

    return instances

def main():
    try:
        hosts = get_instance_by_name(INSTANCE_NAME)

        inventory = {
            "ec2-nginx": {
                "hosts": hosts,
                "vars": {
                    "ansible_ssh_user": "ubuntu"
                }
            },
            "all": {
                "children": ["ec2-nginx"],
                "vars": {
                    "env": "dev",
                    "ansible_ssh_extra_args": "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null",
                    "domain_name": DOMAIN_NAME
                }
            }
        }

        print(json.dumps(inventory))
    except Exception as e:
        print(json.dumps({"_meta": {"hostvars": {}}}))
        raise e

if __name__ == '__main__':
    main()
