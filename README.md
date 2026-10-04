# Lab 00 — Kubernetes Environment Setup

## Goal

Prepare an Ubuntu EC2 instance and create a multi-node Kubernetes cluster using Kind.

## Architecture

```text
                 AWS
                  |
             EC2 Instance
                  |
        +---------+---------+
        |                   |
      Docker              kubectl
        |
       Kind
        |
   +----+-------------------+
   |                        |
control-plane            worker nodes
```

## 1. Create the EC2 instance

Recommended starting point:

- OS: Ubuntu 24.04 LTS
- CPU: 2 vCPU
- RAM: 4 GB minimum
- Disk: 30 GB or more
- SSH: port 22 from your IP

For heavier labs later in the course, 8 GB RAM is recommended.

## 2. Connect to EC2

```bash
ssh -i <key.pem> ubuntu@<EC2_PUBLIC_IP>
```

Update packages:

```bash
sudo apt update
sudo apt upgrade -y
```

## 3. Install Docker

Run:

```bash
./install-docker.sh
```

Log out and back in if required:

```bash
exit
```

Then reconnect and verify:

```bash
docker --version
docker run --rm hello-world
```

## 4. Install kubectl

```bash
./install-kubectl.sh
```

Verify:

```bash
kubectl version --client
```

## 5. Install Kind

```bash
./install-kind.sh
```

Verify:

```bash
kind version
```

## 6. Create the cluster

```bash
kind create cluster \
  --name k8s-lab \
  --config kind-config.yaml
```

## 7. Verify the cluster

```bash
kubectl cluster-info

kubectl get nodes

kubectl get pods -A
```

Expected nodes:

```text
k8s-lab-control-plane
k8s-lab-worker
k8s-lab-worker2
```

All nodes should be `Ready`.

## 8. Useful commands

```bash
kubectl get nodes -o wide
kubectl get namespaces
kubectl get pods -A
kubectl config current-context
kubectl cluster-info
kind get clusters
docker ps
```

## 9. Explore the cluster

Answer these questions:

1. How many nodes are in the cluster?
2. Which node is the control plane?
3. What namespaces exist by default?
4. Which system Pods are running in `kube-system`?
5. What Docker containers were created by Kind?

Useful commands:

```bash
kubectl get nodes
kubectl get ns
kubectl get pods -n kube-system
docker ps
```

## Cleanup

Delete the lab cluster:

```bash
kind delete cluster --name k8s-lab
```

Recreate it:

```bash
kind create cluster \
  --name k8s-lab \
  --config kind-config.yaml
```
