# Command Reference Guide

Quick reference for all commands used throughout the DevOps Lab curriculum.

## 📋 Table of Contents

- [Vagrant Commands](#vagrant-commands)
- [Docker Commands](#docker-commands)
- [Docker Compose Commands](#docker-compose-commands)
- [Kubernetes Commands](#kubernetes-commands)
- [Terraform Commands](#terraform-commands)
- [Ansible Commands](#ansible-commands)
- [System Commands](#system-commands)
- [Network Commands](#network-commands)

---

## Vagrant Commands

### Basic Operations

```bash
# Start VMs
vagrant up                    # Start all VMs
vagrant up VM_NAME            # Start specific VM

# Stop VMs
vagrant halt                  # Stop all VMs gracefully
vagrant halt VM_NAME          # Stop specific VM

# Destroy VMs
vagrant destroy               # Delete all VMs (with confirmation)
vagrant destroy -f            # Force delete without confirmation
vagrant destroy VM_NAME       # Delete specific VM

# Connect to VMs
vagrant ssh                   # SSH to default VM
vagrant ssh VM_NAME           # SSH to specific VM

# Status & Information
vagrant status                # Show VM status
vagrant global-status         # Show all VMs across projects
vagrant port VM_NAME          # Show forwarded ports
```

### Advanced Operations

```bash
# Reload VMs
vagrant reload                # Restart all VMs
vagrant reload VM_NAME        # Restart specific VM

# Provision
vagrant provision             # Re-run provisioning scripts
vagrant provision VM_NAME     # Provision specific VM

# Suspend/Resume
vagrant suspend               # Suspend all VMs
vagrant resume                # Resume suspended VMs

# Box Management
vagrant box list              # List installed boxes
vagrant box add BOX_NAME      # Download box
vagrant box remove BOX_NAME   # Remove box
vagrant box update            # Update boxes
```

### Useful Examples

```bash
# Quick start workflow
vagrant up                    # Start
vagrant ssh                   # Connect
# ... work ...
exit                          # Exit VM
vagrant halt                  # Stop

# Clean rebuild
vagrant destroy -f && vagrant up

# Check what's running
vagrant global-status --prune
```

---

## Docker Commands

### Container Management

```bash
# Run containers
docker run IMAGE              # Run container
docker run -d IMAGE           # Run in background (detached)
docker run -p HOST:GUEST IMAGE  # Port mapping
docker run --name NAME IMAGE  # Named container
docker run -v HOST:GUEST IMAGE # Volume mount

# Container Lifecycle
docker start CONTAINER        # Start stopped container
docker stop CONTAINER         # Stop running container
docker restart CONTAINER      # Restart container
docker pause CONTAINER        # Pause container
docker unpause CONTAINER      # Unpause container
docker kill CONTAINER         # Force stop container
docker rm CONTAINER           # Remove container
docker rm -f CONTAINER        # Force remove running container

# Container Information
docker ps                    # List running containers
docker ps -a               # List all containers
docker ps -l                # List last container
docker ps -q                # List only IDs
docker inspect CONTAINER    # Detailed container info
docker logs CONTAINER       # View logs
docker logs -f CONTAINER    # Follow logs (live)
docker logs --tail 50 CONTAINER  # Last 50 lines
docker top CONTAINER        # Running processes
docker stats CONTAINER      # Resource usage
```

### Image Management

```bash
# Build images
docker build .              # Build from Dockerfile
docker build -t NAME:TAG .  # Build with tag
docker build --no-cache .   # Build without cache

# Image Operations
docker images               # List images
docker images -a            # List all images
docker rmi IMAGE            # Remove image
docker rmi -f IMAGE         # Force remove
docker pull IMAGE           # Download image
docker push IMAGE           # Upload image
docker tag OLD NEW          # Tag image
docker history IMAGE        # Image layers
```

### Execution & Debugging

```bash
# Execute commands
docker exec CONTAINER CMD   # Run command in container
docker exec -it CONTAINER bash  # Interactive shell
docker exec -it CONTAINER sh    # Shell access

# Copy files
docker cp FILE CONTAINER:PATH  # Copy to container
docker cp CONTAINER:PATH FILE   # Copy from container

# Network
docker network ls           # List networks
docker network inspect NET  # Network details
docker network create NET  # Create network
```

### Cleanup

```bash
# Clean up resources
docker system prune         # Remove unused data
docker system prune -a      # Remove all unused
docker system prune -a -f   # Force, no confirmation
docker volume prune         # Remove unused volumes
docker network prune        # Remove unused networks
```

---

## Docker Compose Commands

### Basic Operations

```bash
# Start services
docker-compose up           # Start and show logs
docker-compose up -d        # Start in background
docker-compose up --build   # Rebuild images first

# Stop services
docker-compose stop         # Stop services
docker-compose down         # Stop and remove containers
docker-compose down -v      # Also remove volumes

# Status & Information
docker-compose ps           # List services
docker-compose logs         # View all logs
docker-compose logs SERVICE # View service logs
docker-compose logs -f      # Follow logs
docker-compose top          # Running processes
docker-compose config       # Validate config
```

### Service Management

```bash
# Individual services
docker-compose up SERVICE   # Start specific service
docker-compose stop SERVICE # Stop specific service
docker-compose restart SERVICE  # Restart service
docker-compose scale SERVICE=N   # Scale service

# Execution
docker-compose exec SERVICE CMD  # Run command
docker-compose exec SERVICE bash # Shell access
```

### Useful Examples

```bash
# Development workflow
docker-compose up -d        # Start
docker-compose logs -f      # Watch logs
docker-compose restart      # Restart after changes
docker-compose down         # Clean stop

# Production-like
docker-compose up -d --build
docker-compose ps
docker-compose logs SERVICE
```

---

## Kubernetes Commands

### Basic Operations

```bash
# Cluster info
kubectl cluster-info        # Cluster information
kubectl get nodes           # List nodes
kubectl version             # Version info

# Pods
kubectl get pods            # List pods
kubectl get pods -A         # All namespaces
kubectl get pods -o wide    # More details
kubectl describe pod NAME  # Pod details
kubectl logs POD_NAME       # Pod logs
kubectl logs -f POD_NAME   # Follow logs
kubectl exec -it POD_NAME -- bash  # Shell access
kubectl delete pod NAME     # Delete pod

# Deployments
kubectl get deployments     # List deployments
kubectl describe deployment NAME  # Deployment details
kubectl scale deployment NAME --replicas=N  # Scale
kubectl rollout status deployment NAME  # Rollout status
kubectl rollout undo deployment NAME  # Rollback

# Services
kubectl get services        # List services
kubectl get svc             # Short form
kubectl describe service NAME  # Service details
kubectl expose deployment NAME --port=80 --type=NodePort  # Expose
```

### Apply & Delete

```bash
# Apply configurations
kubectl apply -f FILE.yaml  # Apply from file
kubectl apply -f DIRECTORY/  # Apply all in directory
kubectl create -f FILE.yaml # Create (fails if exists)

# Delete
kubectl delete -f FILE.yaml # Delete from file
kubectl delete deployment NAME  # Delete deployment
kubectl delete service NAME     # Delete service
kubectl delete pod NAME         # Delete pod
```

### Debugging

```bash
# Debugging
kubectl get events           # Recent events
kubectl get events --sort-by='.lastTimestamp'  # Sorted
kubectl top pods             # Resource usage (needs metrics)
kubectl top nodes            # Node resource usage
kubectl port-forward POD PORT  # Port forward
kubectl port-forward svc/SERVICE PORT  # Forward service
```

### Minikube Specific

```bash
# Minikube commands
minikube start               # Start cluster
minikube stop                # Stop cluster
minikube status              # Cluster status
minikube dashboard           # Open dashboard
minikube service SERVICE     # Get service URL
minikube service SERVICE --url  # Service URL only
minikube delete              # Delete cluster
```

### MicroK8s Specific

```bash
# MicroK8s commands
microk8s status              # Cluster status
microk8s kubectl get pods    # Use microk8s prefix
microk8s enable DNS          # Enable addon
microk8s enable dashboard    # Enable dashboard
microk8s dashboard-proxy     # Dashboard access
microk8s stop                # Stop cluster
microk8s start               # Start cluster
```

---

## Terraform Commands

### Basic Workflow

```bash
# Initialize
terraform init               # Initialize working directory
terraform init -upgrade     # Upgrade providers

# Planning
terraform plan              # Show execution plan
terraform plan -out=FILE    # Save plan to file
terraform plan -var="KEY=VALUE"  # Set variable

# Apply
terraform apply             # Apply changes
terraform apply -auto-approve  # Skip confirmation
terraform apply PLAN_FILE   # Apply saved plan

# Destroy
terraform destroy           # Destroy infrastructure
terraform destroy -auto-approve  # Skip confirmation

# State
terraform show              # Show current state
terraform state list        # List resources
terraform state show RESOURCE  # Show resource
terraform refresh           # Refresh state
```

### Advanced Operations

```bash
# Formatting
terraform fmt               # Format files
terraform fmt -check        # Check formatting

# Validation
terraform validate          # Validate configuration
terraform validate -json    # JSON output

# Workspaces
terraform workspace list    # List workspaces
terraform workspace new NAME  # Create workspace
terraform workspace select NAME  # Switch workspace
```

---

## Ansible Commands

### Basic Operations

```bash
# Connection test
ansible all -i inventory.ini -m ping  # Test connectivity
ansible all -i inventory.ini -m ping -u USER  # With user

# Ad-hoc commands
ansible all -i inventory.ini -m shell -a "COMMAND"  # Run command
ansible all -i inventory.ini -a "COMMAND"  # Short form
ansible GROUP -i inventory.ini -m apt -a "name=nginx state=present"  # Install

# Playbooks
ansible-playbook playbook.yml -i inventory.ini  # Run playbook
ansible-playbook playbook.yml -i inventory.ini --check  # Dry run
ansible-playbook playbook.yml -i inventory.ini --limit HOST  # Limit hosts
ansible-playbook playbook.yml -i inventory.ini -v  # Verbose
ansible-playbook playbook.yml -i inventory.ini -vvv  # Very verbose
```

### Inventory & Variables

```bash
# Inventory
ansible-inventory -i inventory.ini --list  # List inventory
ansible-inventory -i inventory.ini --graph  # Graph view

# Vault (secrets)
ansible-vault create FILE   # Create encrypted file
ansible-vault edit FILE      # Edit encrypted file
ansible-vault encrypt FILE  # Encrypt existing file
ansible-vault decrypt FILE   # Decrypt file
ansible-playbook playbook.yml --ask-vault-pass  # Prompt for password
```

---

## System Commands

### Resource Monitoring

```bash
# Memory
free -h                     # Memory usage (human readable)
free -m                     # Memory in MB

# Disk
df -h                       # Disk usage
du -sh DIRECTORY            # Directory size
du -h --max-depth=1         # One level deep

# CPU & Processes
htop                        # Interactive process viewer (install first)
top                        # Process viewer
ps aux                     # All processes
ps aux | grep PROCESS      # Find process

# System info
uname -a                   # System information
hostname                    # Hostname
uptime                     # System uptime
```

### Network

```bash
# Port checking
lsof -i :PORT              # What's using port (macOS/Linux)
netstat -an | grep PORT    # Port status (Linux)
netstat -ano | findstr PORT  # Port status (Windows)

# Network info
ifconfig                   # Network interfaces (Linux/macOS)
ip addr                     # Network interfaces (Linux)
ip route                    # Routing table
ping HOST                   # Test connectivity
curl URL                    # HTTP request
wget URL                    # Download file
```

### File Operations

```bash
# Navigation
pwd                        # Current directory
ls -la                     # List all files
cd DIRECTORY               # Change directory
cd ~                       # Home directory

# File operations
cat FILE                   # View file
less FILE                  # View file (scrollable)
head FILE                  # First 10 lines
tail FILE                  # Last 10 lines
tail -f FILE               # Follow file (live)
grep PATTERN FILE          # Search in file
find . -name PATTERN       # Find files

# Permissions
chmod +x FILE              # Make executable
chmod 755 FILE             # Set permissions
sudo COMMAND               # Run as root
```

---

## Network Commands

### Docker Network

```bash
# Network inspection
docker network ls          # List networks
docker network inspect NET # Network details
docker network create NET  # Create network
docker network rm NET      # Remove network

# Container networking
docker exec CONTAINER nslookup SERVICE  # DNS lookup
docker exec CONTAINER ping HOST         # Ping test
docker exec CONTAINER wget URL          # HTTP test
```

### Kubernetes Network

```bash
# Service discovery
kubectl exec POD -- nslookup SERVICE  # DNS lookup
kubectl exec POD -- ping HOST         # Ping test
kubectl exec POD -- wget URL         # HTTP test

# Port forwarding
kubectl port-forward pod/POD_NAME PORT  # Forward pod port
kubectl port-forward svc/SERVICE PORT   # Forward service port
```

### VM Network

```bash
# From host
vagrant ssh VM_NAME        # SSH to VM
ping VM_IP                  # Test connectivity
curl http://VM_IP:PORT     # Test service

# From VM
ip addr                    # Network interfaces
ip route                   # Routing table
netstat -tuln             # Listening ports
ss -tuln                   # Listening ports (modern)
```

---

## Quick Reference Card

### Most Used Commands

```bash
# Vagrant
vagrant up && vagrant ssh
vagrant halt
vagrant destroy -f

# Docker
docker ps
docker-compose up -d
docker-compose logs -f
docker-compose down

# Kubernetes
kubectl get pods
kubectl get services
kubectl apply -f FILE.yaml
kubectl logs POD_NAME

# System
lsof -i :PORT              # Check port
free -h                    # Memory
df -h                      # Disk
```

---

## Command Aliases (Optional)

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Docker shortcuts
alias dps='docker ps'
alias dpa='docker ps -a'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# Docker Compose shortcuts
alias dcu='docker-compose up -d'
alias dcd='docker-compose down'
alias dcl='docker-compose logs -f'
alias dcp='docker-compose ps'

# Kubernetes shortcuts
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kdp='kubectl describe pod'
alias kl='kubectl logs -f'

# Vagrant shortcuts
alias vu='vagrant up'
alias vh='vagrant halt'
alias vs='vagrant ssh'
alias vd='vagrant destroy -f'
```

Reload: `source ~/.bashrc` or `source ~/.zshrc`

---

**📖 For chapter-specific commands, see individual chapter READMEs.**

