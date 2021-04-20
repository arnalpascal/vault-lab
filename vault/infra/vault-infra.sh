#! /bin/bash

set -xe

source /vagrant/vault-lab.env
source /vagrant/infra/vault-infra.env

podman play kube /vagrant/infra/vault-infra.yml

cd /vagrant/infra/terraform

terraform init
terraform validate
terraform plan -out=tfplan
terraform apply tfplan

mkdir -p $VAULT_TRANSIT_PATH/pki \
         $VAULT_CLUSTER_NODE_1_PATH/pki \
         $VAULT_CLUSTER_NODE_2_PATH/pki \
         $VAULT_CLUSTER_NODE_3_PATH/pki \
         $VAULT_CLUSTER_LB_PATH/pki

terraform output -json pki_infra_ca | jq -r > $VAULT_TRANSIT_PATH/pki/ca.crt
terraform output -json pki_infra_ca | jq -r > $VAULT_CLUSTER_NODE_1_PATH/pki/ca.crt
terraform output -json pki_infra_ca | jq -r > $VAULT_CLUSTER_NODE_2_PATH/pki/ca.crt
terraform output -json pki_infra_ca | jq -r > $VAULT_CLUSTER_NODE_3_PATH/pki/ca.crt
terraform output -json pki_infra_ca | jq -r > $VAULT_CLUSTER_LB_PATH/pki/ca.crt

terraform output -json vault_transit_cert | jq -r > $VAULT_TRANSIT_PATH/pki/vault_transit.crt
terraform output -json vault_transit_private_key | jq -r > $VAULT_TRANSIT_PATH/pki/vault_transit.key

terraform output -json vault_cluster_node_1_cert | jq -r > $VAULT_CLUSTER_NODE_1_PATH/pki/vault_cluster.crt
terraform output -json vault_cluster_node_1_private_key | jq -r > $VAULT_CLUSTER_NODE_1_PATH/pki/vault_cluster.key

terraform output -json vault_cluster_node_2_cert | jq -r > $VAULT_CLUSTER_NODE_2_PATH/pki/vault_cluster.crt
terraform output -json vault_cluster_node_2_private_key | jq -r > $VAULT_CLUSTER_NODE_2_PATH/pki/vault_cluster.key

terraform output -json vault_cluster_node_3_cert | jq -r > $VAULT_CLUSTER_NODE_3_PATH/pki/vault_cluster.crt
terraform output -json vault_cluster_node_3_private_key | jq -r > $VAULT_CLUSTER_NODE_3_PATH/pki/vault_cluster.key

terraform output -json vault_cluster_lb_cert | jq -r > $VAULT_CLUSTER_LB_PATH/pki/vault_cluster_lb.crt
terraform output -json vault_cluster_lb_private_key | jq -r > $VAULT_CLUSTER_LB_PATH/pki/vault_cluster_lb.key