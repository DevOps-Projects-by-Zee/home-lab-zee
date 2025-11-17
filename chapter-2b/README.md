# Chapter 2B: MicroK8s - Linux Native Kubernetes

## Overview
This chapter covers MicroK8s, a lightweight, production-grade Kubernetes distribution that runs natively on Linux without virtual machines. Perfect for Linux users who want a faster, more realistic Kubernetes experience than Minikube.

## Why MicroK8s?

### Advantages Over Minikube
- **No VM Overhead**: Runs directly on your Linux host
- **Production-Grade**: Same Kubernetes as cloud providers use
- **Built-in Addons**: DNS, dashboard, storage included
- **Multi-Node Capable**: Add nodes to create a real cluster
- **Snap-Based**: Automatic updates, easy installation
- **Lightweight**: Runs in as little as 540MB RAM

### When to Use MicroK8s
✅ **Use MicroK8s when:**
- Running on Linux natively
- Want production-grade Kubernetes
- Need built-in addon ecosystem
- Building CI/CD pipelines
- Learning multi-node clustering
- Want faster startup times

❌ **Don't use MicroK8s when:**
- On Mac or Windows (use Minikube instead)
- Need VM isolation from host
- Following cross-platform tutorials

## Files Included

### `nginx-deployment.yaml`
- Kubernetes deployment with 3 nginx replicas
- NodePort service on port 30080
- Resource limits and requests
- Security context configuration

## Prerequisites

- **OS**: Ubuntu 18.04+ or Linux with snap support
- **RAM**: 4GB minimum, 8GB recommended
- **Disk**: 20GB free space
- **Network**: Internet connection for initial setup

## Quick Start

### 1. Install MicroK8s
```bash
# Check if snap is available
snap version

# Install MicroK8s with specific Kubernetes version
sudo snap install microk8s --classic --channel=1.29/stable

# Add user to microk8s group
sudo usermod -aG microk8s $USER

# Create .kube directory
sudo mkdir -p ~/.kube
sudo chown -f -R $USER ~/.kube

# Apply group changes
newgrp microk8s
```

### 2. Verify Installation
```bash
# Check cluster status
microk8s status --wait-ready

# Verify nodes
microk8s kubectl get nodes
```

### 3. Enable Essential Addons
```bash
# Enable DNS (required for most applications)
microk8s enable dns

# Enable storage
microk8s enable hostpath-storage

# Enable dashboard (optional)
microk8s enable dashboard
```

### 4. Deploy Application
```bash
# Deploy nginx application
microk8s kubectl apply -f nginx-deployment.yaml

# Watch deployment progress
microk8s kubectl get pods -w

# Check service
microk8s kubectl get services
```

### 5. Access Your Application

**Method 1: Direct Access (Recommended)**
```bash
# Access via VM's private network IP
# If running in Vagrant VM: http://192.168.56.10:30080
# If running on Linux host: http://localhost:30080
```

**Method 2: Port Forwarding (If Method 1 doesn't work)**
```bash
# Add to Vagrantfile (if using VM):
# jenkins.vm.network "forwarded_port", guest: 30080, host: 30080

# Then reload VM
vagrant reload jenkins

# Access via localhost
# http://localhost:30080
```

**Method 3: kubectl Port Forward (Temporary)**
```bash
microk8s kubectl port-forward svc/nginx-service 30080:80 --address 0.0.0.0
# Keep terminal open, then access: http://localhost:30080
```

## Setup kubectl Access

### Option 1: Use microk8s prefix (Recommended for learning)
```bash
microk8s kubectl get pods --all-namespaces
```

### Option 2: Create alias (Convenient)
```bash
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
source ~/.bashrc
```

### Option 3: Export config for regular kubectl
```bash
# Install regular kubectl first
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Export MicroK8s config
microk8s config > ~/.kube/config

# Now regular kubectl works
kubectl get nodes
```

## Access Kubernetes Dashboard

### Enable Dashboard
```bash
microk8s enable dashboard
```

### Start Dashboard Proxy
```bash
microk8s dashboard-proxy
```

**Output:**
```
Dashboard will be available at https://127.0.0.1:10443
Use the following token to login:
eyJhbGciOiJSUzI1NiIsImtpZCI6...
```

### Access Dashboard
1. Open browser: `https://127.0.0.1:10443`
2. Paste the token from the output above
3. You'll see the Kubernetes dashboard!

## Essential Commands

### Cluster Management
```bash
microk8s status                    # Check cluster status
microk8s stop                      # Stop cluster
microk8s start                     # Start cluster
microk8s reset                     # Reset cluster (destructive!)
```

### Kubectl Commands
```bash
microk8s kubectl get pods         # List pods
microk8s kubectl get services     # List services
microk8s kubectl get nodes        # List nodes
microk8s kubectl describe pod <pod-name>  # Pod details
microk8s kubectl logs <pod-name>  # View logs
```

### Addons Management
```bash
microk8s enable <addon>           # Enable addon
microk8s disable <addon>          # Disable addon
microk8s status                   # See enabled/disabled addons
```

### Scaling and Updates
```bash
microk8s kubectl scale deployment nginx --replicas=5  # Scale to 5 pods
microk8s kubectl delete -f nginx-deployment.yaml      # Remove deployment
```

## Useful Addons

### Core Addons for Learning
```bash
microk8s enable dns               # DNS resolution (required)
microk8s enable dashboard         # Web dashboard
microk8s enable hostpath-storage  # Local storage
microk8s enable metrics-server    # Resource metrics
```

### Advanced Addons
```bash
microk8s enable registry          # Private registry on localhost:32000
microk8s enable ingress            # Nginx ingress controller  
microk8s enable prometheus         # Monitoring stack
microk8s enable metallb            # Load balancer
```

**Note**: When enabling metallb, it will ask for an IP range. Use your local network range:
```bash
# Find your network range
ip route | grep default

# Example: default via 192.168.1.1 dev wlan0
# Use range like: 192.168.1.240-192.168.1.250
```

## Architecture

```
Linux Host → MicroK8s → Kubernetes Cluster
                ↓
        ┌───────┴───────┐
        │               │
    Control Plane    Worker Nodes
        │               │
    API Server      Pods (nginx)
    etcd            Services
    Scheduler       NodePort (30080)
```

## What You'll Learn

- **Native Kubernetes**: Production-grade K8s without VM overhead
- **Service Discovery**: DNS-based service resolution
- **Resource Management**: CPU and memory limits
- **NodePort Services**: Exposing applications externally
- **Addon Ecosystem**: Built-in tools for common tasks
- **Multi-Node Clustering**: Scale to multiple nodes

## Troubleshooting

### Command not found: microk8s
```bash
# Install snap if missing
sudo apt update && sudo apt install snapd

# Restart terminal or add to PATH
export PATH=$PATH:/snap/bin
echo 'export PATH=$PATH:/snap/bin' >> ~/.bashrc
```

### Permission denied errors
```bash
# Add user to microk8s group
sudo usermod -aG microk8s $USER
newgrp microk8s

# Or log out and back in
```

### Cluster not starting
```bash
# Wait longer or check detailed status
microk8s status --wait-ready
microk8s inspect

# Check system resources
free -h
df -h
```

### Pods stuck in Pending/ContainerCreating
```bash
# DNS addon might not be enabled
microk8s enable dns
microk8s kubectl get pods --all-namespaces

# Wait 1-2 minutes for DNS to start
```

### Can't access NodePort service
```bash
# Check if service is actually running
microk8s kubectl get services

# Should show 80:30080/TCP for nginx-service

# Test locally first
curl http://localhost:30080

# Check if port is blocked
sudo netstat -tlnp | grep 30080
```

### Dashboard won't load
```bash
# Dashboard proxy not running
pkill -f dashboard-proxy

# Start fresh
microk8s dashboard-proxy
```

### High memory usage
```bash
# Check resource usage
free -h
microk8s kubectl top nodes  # Requires metrics-server addon

# Stop when not needed
microk8s stop
```

## Performance Tips

### Resource-Constrained Systems
```bash
# Use fewer replicas
microk8s kubectl scale deployment nginx --replicas=1

# Disable unnecessary addons
microk8s disable dashboard  # When not using
microk8s disable metrics-server  # If not monitoring

# Stop when not in use
microk8s stop
```

### Speed up deployments
```bash
# Use local registry to avoid repeated downloads
microk8s enable registry

# Tag and push images locally
microk8s kubectl run test --image=localhost:32000/nginx:alpine
```

## Clean Up

### Remove Deployment
```bash
microk8s kubectl delete -f nginx-deployment.yaml
```

### Stop MicroK8s
```bash
microk8s stop
```

### Complete Removal
```bash
microk8s stop
sudo snap remove microk8s
```

**Warning**: This removes everything, including all deployments and cluster data.

## MicroK8s vs Minikube Comparison

| Feature | MicroK8s | Minikube |
|---------|----------|----------|
| **Platform** | Linux only | Mac, Windows, Linux |
| **Overhead** | ~540MB RAM | ~2GB RAM |
| **Startup Time** | Fast (~30s) | Slower (~2-3 min) |
| **Production-Grade** | Yes | No (learning tool) |
| **Multi-Node** | Yes | Limited |
| **Addons** | Built-in | Plugin-based |
| **Updates** | Automatic (snap) | Manual |

**Both teach identical Kubernetes skills. Choose based on your platform and learning goals.**

## Key Takeaways

1. **Native Performance**: MicroK8s runs directly on Linux for better performance
2. **Production Patterns**: Learn the same Kubernetes patterns used in production
3. **Addon Ecosystem**: Built-in tools make common tasks easier
4. **Resource Efficient**: Uses less RAM than VM-based solutions
5. **Real Clustering**: Can create multi-node clusters for advanced learning

## Next Steps

After mastering MicroK8s basics:
- Add more nodes to create a multi-node cluster
- Deploy complex applications with multiple services
- Set up CI/CD pipelines with Jenkins
- Implement service mesh (Istio)
- Add monitoring with Prometheus
- Practice rolling updates and rollbacks

This is production-grade Kubernetes running on your laptop - the same skills transfer directly to cloud platforms!

