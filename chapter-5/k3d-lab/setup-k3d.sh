#!/bin/bash
set -e

echo "=== Installing Docker ==="
apt-get update
apt-get install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
usermod -aG docker vagrant

echo "=== Installing k3d ==="
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

echo "=== Installing kubectl ==="
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

echo "=== Creating k3d cluster ==="
k3d cluster create devlab \
  --agents 2 \
  --port 8080:80@loadbalancer \
  --port 8081:443@loadbalancer \
  --k3s-arg '--disable=traefik@server:*'

echo "=== Cluster ready! ==="
kubectl get nodes

echo ""
echo "✅ k3d cluster created successfully!"
echo ""
echo "=== LoadBalancer Service Setup ==="
echo "To create a LoadBalancer service that works with k3d:"
echo "1. Create deployment: kubectl create deployment nginx --image=nginx:alpine --replicas=2"
echo "2. Expose service: kubectl expose deployment nginx --type=LoadBalancer --port=80 --target-port=80"
echo "3. Access via: http://localhost:8080 (LoadBalancer accessible on port 8080)"
echo ""
echo "SSH in with: vagrant ssh"
echo "Then run: kubectl get nodes"
