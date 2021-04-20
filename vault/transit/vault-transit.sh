#! /bin/bash

set -xe

source /vagrant/vault-lab.env
source /vagrant/transit/vault-transit.env

mkdir -p $VAULT_TRANSIT_DATA_PATH
chmod 777 $VAULT_TRANSIT_DATA_PATH

chcon -Rt svirt_sandbox_file_t $VAULT_TRANSIT_PATH

podman play kube /vagrant/transit/vault-transit.yml

vault operator init -format=json --key-shares=1 -key-threshold=1 > operator_init.json

vault operator unseal -format=json $(cat operator_init.json | jq -r .unseal_keys_b64[0]) > operator_unseal.json

export VAULT_TOKEN=$(cat operator_init.json | jq -r .root_token)

echo "export VAULT_TOKEN=$VAULT_TOKEN" >> /vagrant/transit/vault-transit.env

cd /vagrant/transit/terraform

terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan

export VAULT_CLUSTER_NODE_1_UNSEAL_TOKEN=$(terraform output vault_cluster_node_1_unseal_token | jq -r)

export VAULT_CLUSTER_NODE_2_UNSEAL_TOKEN=$(terraform output vault_cluster_node_2_unseal_token | jq -r)

export VAULT_CLUSTER_NODE_3_UNSEAL_TOKEN=$(terraform output vault_cluster_node_3_unseal_token | jq -r)

 envsubst < $VAULT_CLUSTER_PATH/vault-cluster-node-1.yml.tpl > $VAULT_CLUSTER_PATH/vault-cluster-node-1.yml
 envsubst < $VAULT_CLUSTER_PATH/vault-cluster-node-2.yml.tpl > $VAULT_CLUSTER_PATH/vault-cluster-node-2.yml
 envsubst < $VAULT_CLUSTER_PATH/vault-cluster-node-3.yml.tpl > $VAULT_CLUSTER_PATH/vault-cluster-node-3.yml