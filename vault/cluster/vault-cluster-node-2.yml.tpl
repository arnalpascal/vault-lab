---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: vault-deployment-cluster-node-2
  labels:
    app: vault-cluster-node-2
spec:
  # no automatic service with podman, so dupplicate Deployment
  replicas: 1
  selector:
    matchLabels:
      app: vault-cluster-node-2
  template:
    metadata:
      labels:
        app: vault-cluster-node-2
    spec:
      containers:
      - name: vault-cluster-node-2
        image: docker.io/hashicorp/vault:1.6.2
        args: ["server", "-config", "/cluster/vault-cluster.hcl"]
        env:
          - name: "VAULT_DISABLE_MLOCK"
            value: "true"
          - name: "SKIP_CHOWN"
            value: "true"
          - name: "SKIP_SETCAP"
            value: "true"
          - name: "VAULT_TOKEN"
            value: "$VAULT_CLUSTER_NODE_2_UNSEAL_TOKEN"
          - name: "VAULT_RAFT_NODE_ID"
            value: "raft_node_2"
          - name: "VAULT_API_ADDR"
            value: "https://vault:8220"
          - name: "VAULT_CLUSTER_ADDR"
            value: "https://vault:8221"
        ports:
          - containerPort: 8200
            protocol: TCP
            hostPort: 8220
          - containerPort: 8201
            protocol: TCP
            hostPort: 8221
        securityContext:
          seLinuxOptions:
            level: "s0"
        volumeMounts:
        - mountPath: /cluster/node
          name: volume-vault-cluster-node-2
        - mountPath: /cluster/vault-cluster.hcl
          name: volume-vault-cluster
      volumes:
      - name: volume-vault-cluster
        hostPath: 
          path: /vagrant/cluster/vault_cluster/vault-cluster.hcl
          type: File
      - name: volume-vault-cluster-node-2
        hostPath: 
          path: /vagrant/cluster/vault_cluster_node_2
          type: Directory
