# Chapter 2: Containers

## Overview
This chapter covers Docker containers and Kubernetes orchestration, teaching you how to package applications and manage them at scale.

## Files Included

### Docker Files
- **`Dockerfile`** - Custom nginx image with custom HTML
- **`index.html`** - Custom web page content
- **`docker-compose.yml`** - Multi-container application (web + database)
- **`install-docker.sh`** - Cross-platform Docker installation script

### Kubernetes Files
- **`nginx-deployment.yaml`** - Kubernetes deployment and service
- **`install-k8s-tools.sh`** - kubectl and minikube installation script

## Quick Start

### Docker Basics
```bash
# Install Docker
./install-docker.sh

# Run first container
docker run -d -p 8080:80 --name web nginx

# Build custom image
docker build -t myapp:v1 .
docker run -d -p 8080:80 myapp:v1

# Multi-container app
docker-compose up -d
```

### Kubernetes
```bash
# Install tools
./install-k8s-tools.sh

# Start cluster
minikube start --driver=docker

# Deploy application
kubectl apply -f nginx-deployment.yaml
kubectl get pods
minikube service nginx --url
```

## What You'll Learn

- **Containerization**: Package applications with Docker
- **Docker Compose**: Multi-container applications
- **Kubernetes**: Container orchestration
- **Deployments**: Scale applications automatically
- **Services**: Expose applications to the network

## Architecture

### Docker Compose
```
Your Computer → Docker Compose → Web Container + Database Container
```

### Kubernetes
```
Minikube Cluster → Pods (3x nginx) → Service → External Access
```

## Essential Commands

### Docker
```bash
docker ps                    # List running containers
docker images                # List images
docker logs <container>      # View logs
docker exec -it <container> bash  # Shell into container
docker-compose up -d         # Start multi-container app
docker-compose down          # Stop multi-container app
```

### Kubernetes
```bash
kubectl get pods             # List pods
kubectl get services         # List services
kubectl logs <pod-name>     # View logs
kubectl scale deployment nginx --replicas=5  # Scale
kubectl delete -f file.yaml # Remove resources
```

## Troubleshooting

- **Port conflicts**: Change port mappings in docker-compose.yml
- **Minikube issues**: Restart with `minikube delete && minikube start`
- **Image pull errors**: Check internet connection and Docker daemon

Ready for Chapter 3: Infrastructure as Code!
