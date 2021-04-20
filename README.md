# vault-lab

Start a Vault lab with podman on fedora.
Go to /vagrant and start vault with
```
./vault-lab.sh
```
This lab start a couple of Vault server :
1. One Vault server that generate and infra PKI, i.e., PKI for others Vault servers
1. One Vault transit for auto unseal a cluster
1. Three Vault servers with embedded raft storage that compose one cluster

The cluster define one PKI with a root and a intermediate CA.

To generate certificate / private key :
1. Source the cluster environment variable file  
```. cluster/vault-cluster.env```
1. Use Vault to generate private keys and certficates  
```vault write -format=json pki-int/issue/pki-int-role common_name=test.org sans=other.org ip_sans=10.0.0.1```