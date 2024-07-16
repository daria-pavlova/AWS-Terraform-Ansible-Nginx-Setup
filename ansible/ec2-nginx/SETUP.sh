#!/bin/sh

set -eu

if [[ "${DEBUG:-false}" = true ]]; then
    set -x
fi

export DOMAIN_NAME="nginx-api.pp.ua"
export INSTANCE_NAME="tf-nginx-api-test-vm"