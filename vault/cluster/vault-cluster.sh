#! /bin/bash

set -xe

source /vagrant/vault-lab.env
source $VAULT_CLUSTER_PATH/vault-cluster.env

chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_CONFIG_PATH

mkdir -p $VAULT_CLUSTER_NODE_1_DATA_PATH
chmod 777 $VAULT_CLUSTER_NODE_1_DATA_PATH

chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_NODE_1_DATA_PATH
chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_NODE_1_PATH

mkdir -p $VAULT_CLUSTER_NODE_2_DATA_PATH
chmod 777 $VAULT_CLUSTER_NODE_2_DATA_PATH

chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_NODE_2_DATA_PATH
chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_NODE_2_PATH

mkdir -p $VAULT_CLUSTER_NODE_3_DATA_PATH
chmod 777 $VAULT_CLUSTER_NODE_3_DATA_PATH

chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_NODE_3_DATA_PATH
chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_NODE_3_PATH

chcon -Rt svirt_sandbox_file_t $VAULT_CLUSTER_PATH

podman play kube $VAULT_CLUSTER_PATH/vault-cluster-node-1.yml
podman play kube $VAULT_CLUSTER_PATH/vault-cluster-node-2.yml
podman play kube $VAULT_CLUSTER_PATH/vault-cluster-node-3.yml
podman play kube $VAULT_CLUSTER_PATH/vault-cluster-lb.yml

export VAULT_TOKEN=$(vault operator init | grep -i root | cut -d " " -f 4)

echo "export VAULT_TOKEN=$VAULT_TOKEN" >> $VAULT_CLUSTER_PATH/vault-cluster.env

. $VAULT_CLUSTER_PATH/vault-cluster.env

echo "Wait Vault is up and running"
sleep 5

cd $VAULT_CLUSTER_PATH/terraform

terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
