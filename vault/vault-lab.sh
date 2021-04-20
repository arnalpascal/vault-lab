#! /bin/bash

set -xe

for v in $(env | grep -i "^vault" | cut -d "=" -f 1); do
  unset $v;
done

podman pod rm -f $(podman pod list -q) || echo "No pod..."

/vagrant/infra/vault-infra.sh

/vagrant/transit/vault-transit.sh

/vagrant/cluster/vault-cluster.sh