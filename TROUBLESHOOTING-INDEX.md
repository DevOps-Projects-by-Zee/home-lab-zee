# Troubleshooting Index

## Overview
This comprehensive troubleshooting index helps you quickly find solutions to common problems encountered throughout the DevOps Pipeline curriculum. Problems are categorized by type and include diagnostic commands and solutions.

## Quick Navigation

- [Port Conflicts](#port-conflicts)
- [Docker Issues](#docker-issues)
- [Vagrant/VM Issues](#vagrantvm-issues)
- [Kubernetes Issues](#kubernetes-issues)
- [Network Issues](#network-issues)
- [Service Issues](#service-issues)
- [Ansible Issues](#ansible-issues)
- [Terraform Issues](#terraform-issues)
- [Jenkins Issues](#jenkins-issues)
- [Monitoring Issues](#monitoring-issues)
- [Database Issues](#database-issues)
- [General Diagnostics](#general-diagnostics)

---

## Port Conflicts

### Problem: Port Already in Use

**Symptoms:**
```
Vagrant cannot forward the specified ports...
The forwarded port to 8080 is already in use.
```

**Diagnostic Commands:**
```bash
# Find what's using the port
lsof -i :8080                    # macOS/Linux
netstat -ano | findstr :8080     # Windows

# Check all forwarded ports
vagrant port VM_NAME
```

**Solutions:**
1. **Kill the conflicting process:**
   ```bash
   kill -9 $(lsof -ti:8080)      # macOS/Linux
   taskkill /PID <PID> /F         # Windows
   ```

2. **Change the port in Vagrantfile:**
   ```ruby
   config.vm.network "forwarded_port", guest: 8080, host: 8086
   ```

3. **Use a different port range:**
   - Use ports 8000-8999 for web services
   - Use ports 5000-5999 for applications
   - Use ports 9000-9999 for monitoring

**Related Issues:**
- [Port Reference Guide](PORT-REFERENCE.md)
- macOS AirPlay on port 5000
- ControlCenter on port 8080

---

## Docker Issues

### Problem: Docker Won't Start

**Symptoms:**
```
Cannot connect to Docker daemon
Docker daemon is not running
```

**Diagnostic Commands:**
```bash
# Check Docker status
sudo systemctl status docker      # Linux
docker info                       # All platforms

# Check Docker service
sudo systemctl start docker       # Linux
```

**Solutions:**
1. **Start Docker service:**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

2. **Restart Docker Desktop** (macOS/Windows)

3. **Check permissions:**
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   ```

**Related Files:**
- Chapter 1: Docker installation
- Chapter 6: Docker setup in VMs

---

### Problem: Docker Installation Fails on Ubuntu Focal

**Symptoms:**
```
E: Unable to locate package docker-model-plugin
DEPRECATION WARNING: This Linux distribution (ubuntu focal) reached end-of-life
```

**Solutions:**
1. **Use apt instead of Docker script:**
   ```bash
   sudo apt-get update --allow-releaseinfo-change
   sudo apt-get install -y docker.io docker-compose
   sudo systemctl start docker
   sudo usermod -aG docker vagrant
   ```

2. **Add retry logic** (already in Vagrantfiles):
   ```bash
   for i in 1 2 3 4 5; do
     apt-get update --allow-releaseinfo-change && break || sleep 10
   done
   ```

**Related Files:**
- `chapter-6/production-lab/Vagrantfile`
- Chapter 1: Docker installation guide

---

### Problem: Docker Compose Version Unsupported

**Symptoms:**
```
Version in "./docker-compose.yml" is unsupported.
You might be seeing this error because you're using the wrong Compose file version.
```

**Solutions:**
1. **Change version in docker-compose.yml:**
   ```yaml
   version: '3.3'  # Instead of '3.8'
   ```

2. **Check Docker Compose version:**
   ```bash
   docker-compose --version
   ```

**Related Files:**
- All `docker-compose.yml` files
- Chapter 2: Docker Compose setup

---

### Problem: Permission Denied (Docker)

**Symptoms:**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Solutions:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Apply changes (choose one):
newgrp docker          # Immediate (current session)
# OR
exit && vagrant ssh    # New session
```

**Related Issues:**
- Docker daemon not running
- User not in docker group

---

### Problem: Container Won't Start

**Symptoms:**
```
Container exits immediately
Container status: Exited (1)
```

**Diagnostic Commands:**
```bash
# Check container logs
docker logs CONTAINER_NAME

# Check container status
docker ps -a

# Inspect container
docker inspect CONTAINER_NAME
```

**Solutions:**
1. **Check logs for errors:**
   ```bash
   docker logs CONTAINER_NAME --tail 50
   ```

2. **Check resource constraints:**
   ```bash
   free -h
   df -h
   ```

3. **Rebuild container:**
   ```bash
   docker-compose down
   docker-compose up -d --build
   ```

**Related Issues:**
- Out of memory
- Port conflicts
- Configuration errors

---

## Vagrant/VM Issues

### Problem: VM Won't Start

**Symptoms:**
```
Vagrant failed to boot the VM
The guest machine entered an invalid state
```

**Diagnostic Commands:**
```bash
# Check VM status
vagrant status

# Check VirtualBox
VBoxManage list runningvms

# Check system resources
free -h
df -h
```

**Solutions:**
1. **Restart VM:**
   ```bash
   vagrant reload VM_NAME
   ```

2. **Destroy and recreate:**
   ```bash
   vagrant destroy -f VM_NAME
   vagrant up VM_NAME
   ```

2. **Check virtualization:**
   ```bash
   # macOS
   sysctl -a | grep VMX
   
   # Linux
   egrep -c '(vmx|svm)' /proc/cpuinfo
   
   # Windows
   systeminfo | findstr "Hyper-V"
   ```

**Related Issues:**
- Insufficient RAM
- Virtualization not enabled
- VirtualBox issues

---

### Problem: SSH Connection Failed

**Symptoms:**
```
ssh: connect to host 127.0.0.1 port 2222: Connection refused
```

**Solutions:**
1. **Check VM is running:**
   ```bash
   vagrant status
   ```

2. **Reload VM:**
   ```bash
   vagrant reload VM_NAME
   ```

3. **Check SSH key:**
   ```bash
   vagrant ssh-config VM_NAME
   ```

**Related Issues:**
- VM not started
- Network configuration issues

---

### Problem: Hash Sum Mismatch / Network Failure

**Symptoms:**
```
E: Failed to fetch http://archive.ubuntu.com/ubuntu/...
Hash Sum mismatch
Temporary failure resolving 'archive.ubuntu.com'
```

**Solutions:**
1. **Use retry logic** (already in Vagrantfiles):
   ```bash
   for i in 1 2 3 4 5; do
     apt-get update --allow-releaseinfo-change && break || sleep 10
   done
   ```

2. **Wait for network:**
   ```bash
   sleep 5  # Wait for network to be ready
   ```

3. **Use --fix-missing flag:**
   ```bash
   apt-get install -y --fix-missing docker.io
   ```

**Related Files:**
- `chapter-6/production-lab/Vagrantfile`
- All provisioning scripts

---

## Kubernetes Issues

### Problem: LoadBalancer Stuck in Pending

**Symptoms:**
```
kubectl get services
NAME    TYPE           EXTERNAL-IP   PORT(S)
webapp  LoadBalancer   <pending>     80:31234/TCP
```

**Solutions:**
1. **For k3d - Disable Traefik:**
   ```bash
   k3d cluster delete devlab
   k3d cluster create devlab \
     --agents 2 \
     --port 8080:80@loadbalancer \
     --k3s-arg '--disable=traefik@server:*'
   ```

2. **For MicroK8s - Enable MetalLB:**
   ```bash
   microk8s enable metallb
   # Enter IP range when prompted
   ```

**Related Files:**
- `chapter-5/k3d-lab/setup-k3d.sh`
- Chapter 2B: MicroK8s setup

---

### Problem: kubectl Command Not Found

**Symptoms:**
```
kubectl: command not found
```

**Solutions:**
1. **Install kubectl:**
   ```bash
   # macOS
   brew install kubectl
   
   # Linux
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   chmod +x kubectl
   sudo mv kubectl /usr/local/bin/
   ```

2. **For MicroK8s - Use prefix:**
   ```bash
   microk8s kubectl get pods
   ```

3. **Export MicroK8s config:**
   ```bash
   microk8s config > ~/.kube/config
   ```

**Related Files:**
- Chapter 2: Kubernetes setup
- Chapter 2B: MicroK8s setup

---

### Problem: Pods Stuck in Pending/ContainerCreating

**Symptoms:**
```
kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
nginx-xxx               0/1     ContainerCreating   0          5m
```

**Diagnostic Commands:**
```bash
# Check pod details
kubectl describe pod POD_NAME

# Check events
kubectl get events --sort-by='.lastTimestamp'

# Check node resources
kubectl top nodes
```

**Solutions:**
1. **Enable DNS (MicroK8s):**
   ```bash
   microk8s enable dns
   ```

2. **Check resource constraints:**
   ```bash
   free -h
   df -h
   ```

3. **Check image pull:**
   ```bash
   kubectl describe pod POD_NAME | grep -i image
   ```

**Related Issues:**
- DNS not enabled
- Insufficient resources
- Image pull errors

---

## Network Issues

### Problem: Container Networking - Services Can't Communicate

**Symptoms:**
```
Get "http://flask-app:5000/metrics": dial tcp: lookup flask-app: no such host
Prometheus target shows DOWN
```

**Diagnostic Commands:**
```bash
# Check container networks
docker network ls
docker network inspect NETWORK_NAME

# Test DNS resolution
docker exec CONTAINER nslookup SERVICE_NAME

# Test connectivity
docker exec CONTAINER wget -qO- http://SERVICE_NAME:PORT
```

**Solutions:**
1. **Ensure containers on same network:**
   ```yaml
   # docker-compose.yml
   services:
     app:
       networks:
         - shared_network
     prometheus:
       networks:
         - shared_network  # Same network!
   ```

2. **Check service names match:**
   ```yaml
   # Service name in docker-compose.yml must match target in config
   services:
     flask-app:  # This is the service name
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/debugging/`
- Chapter 6: Container networking debugging

---

### Problem: Can't Access Service from Host

**Symptoms:**
```
curl: (7) Failed to connect to localhost:8080: Connection refused
This site can't be reached
```

**Diagnostic Commands:**
```bash
# Check if service is running
vagrant ssh VM_NAME
docker ps

# Check port forwarding
vagrant port VM_NAME

# Test from inside VM
curl http://localhost:PORT
```

**Solutions:**
1. **Check port forwarding in Vagrantfile:**
   ```ruby
   config.vm.network "forwarded_port", guest: 8080, host: 8086
   ```

2. **Reload VM to apply changes:**
   ```bash
   vagrant reload VM_NAME
   ```

3. **Access via VM IP:**
   ```bash
   curl http://192.168.56.10:8080  # Direct VM access
   ```

**Related Issues:**
- Port conflicts
- Service not running
- Port forwarding misconfiguration

---

## Service Issues

### Problem: Flask App Returns 404

**Symptoms:**
```
404 Not Found
The requested URL was not found on the server
```

**Solutions:**
1. **Add root route:**
   ```python
   @app.route('/')
   def index():
       return jsonify({'message': 'API is running'})
   ```

2. **Check route definitions:**
   ```bash
   curl http://localhost:5006/
   curl http://localhost:5006/health
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/app.py`

---

### Problem: Flask App Container Unhealthy

**Symptoms:**
```
docker ps
CONTAINER    STATUS
flask-app    (unhealthy)
```

**Diagnostic Commands:**
```bash
# Check health check
docker inspect flask-app | grep -A 10 Healthcheck

# Check logs
docker logs flask-app

# Test health endpoint manually
docker exec flask-app curl http://localhost:5000/health
```

**Solutions:**
1. **Install curl in Dockerfile:**
   ```dockerfile
   RUN apt-get install -y curl
   ```

2. **Check health check command:**
   ```dockerfile
   HEALTHCHECK --interval=30s --timeout=10s \
     CMD curl -f http://localhost:5000/health || exit 1
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/Dockerfile`

---

## Ansible Issues

### Problem: Permission Denied (Publickey)

**Symptoms:**
```
vagrant@192.168.56.10: Permission denied (publickey)
```

**Solutions:**
1. **Check inventory file:**
   ```ini
   [webservers]
   web1 ansible_host=192.168.56.10 ansible_user=vagrant
   ansible_ssh_private_key_file=../.vagrant/machines/web1/virtualbox/private_key
   ```

2. **Test SSH manually:**
   ```bash
   vagrant ssh web1
   ```

3. **Add SSH key to known_hosts:**
   ```bash
   ssh-keyscan 192.168.56.10 >> ~/.ssh/known_hosts
   ```

**Related Files:**
- `chapter-5/ansible/inventory.ini`
- Chapter 3: Ansible setup

---

### Problem: Ansible Command Not Found

**Symptoms:**
```
ansible: command not found
```

**Solutions:**
```bash
# macOS
brew install ansible

# Linux
sudo apt install ansible

# Add to PATH if needed
export PATH=$PATH:/usr/local/opt/ansible/bin
```

---

## Terraform Issues

### Problem: Terraform Provider Not Found

**Symptoms:**
```
Error: Failed to query available provider packages
```

**Solutions:**
```bash
# Initialize providers
terraform init

# Update providers
terraform init -upgrade
```

---

## Jenkins Issues

### Problem: Jenkins Won't Start

**Symptoms:**
```
Container exits immediately
Cannot access Jenkins web UI
```

**Diagnostic Commands:**
```bash
# Check container status
docker ps | grep jenkins

# Check logs
docker-compose logs jenkins

# Check port
lsof -i :8080
```

**Solutions:**
1. **Check Docker socket mounting:**
   ```yaml
   volumes:
     - /var/run/docker.sock:/var/run/docker.sock
   ```

2. **Restart Jenkins:**
   ```bash
   docker-compose restart jenkins
   ```

3. **Check port conflicts:**
   ```bash
   lsof -i :8080
   ```

**Related Files:**
- `chapter-6/production-lab/jenkins-vm/docker-compose.yml`
- `chapter-6/production-lab/jenkins-vm/JENKINS-SETUP.md`

---

### Problem: Jenkins Can't Build Docker Images

**Symptoms:**
```
Cannot connect to Docker daemon
docker: command not found
```

**Solutions:**
1. **Mount Docker socket and binary:**
   ```yaml
   volumes:
     - /var/run/docker.sock:/var/run/docker.sock
     - /usr/bin/docker:/usr/bin/docker
   ```

2. **Run as root:**
   ```yaml
   user: root
   ```

**Related Files:**
- `chapter-6/production-lab/jenkins-vm/docker-compose.yml`

---

## Monitoring Issues

### Problem: Prometheus Targets Show DOWN

**Symptoms:**
```
Prometheus UI → Status → Targets
Endpoint: http://flask-app:5000/metrics
State: DOWN
```

**Diagnostic Commands:**
```bash
# Check Prometheus config
docker exec prometheus cat /etc/prometheus/prometheus.yml

# Test target manually
docker exec prometheus wget -qO- http://flask-app:5000/metrics

# Check DNS resolution
docker exec prometheus nslookup flask-app
```

**Solutions:**
1. **Ensure containers on same network** (see Container Networking above)

2. **Check target configuration:**
   ```yaml
   scrape_configs:
     - job_name: 'flask-app'
       static_configs:
         - targets: ['flask-app:5000']  # Service name must match!
   ```

3. **Verify service is running:**
   ```bash
   docker ps | grep flask-app
   curl http://localhost:5006/metrics
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/prometheus.yml`
- Chapter 6: Container networking debugging

---

### Problem: Grafana Dashboard Not Appearing

**Symptoms:**
```
Dashboard doesn't show in Grafana UI
"Dashboard title cannot be empty" in logs
```

**Solutions:**
1. **Check dashboard JSON format:**
   ```json
   {
     "uid": "dashboard-id",
     "title": "Dashboard Title",
     "version": 1,
     "schemaVersion": 16,
     "panels": [...]
   }
   ```

2. **Check provisioning path:**
   ```yaml
   volumes:
     - ./grafana-dashboards:/etc/grafana/provisioning/dashboards
   ```

3. **Restart Grafana:**
   ```bash
   docker-compose restart grafana
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/grafana-dashboards/`

---

### Problem: Grafana Datasource Not Found

**Symptoms:**
```
Datasource named prometheus not found
```

**Solutions:**
1. **Set explicit UID in datasource:**
   ```yaml
   datasources:
     - name: Prometheus
       uid: prometheus  # Explicit UID
       url: http://prometheus:9090
   ```

2. **Restart Grafana:**
   ```bash
   docker-compose restart grafana
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/grafana-datasources/prometheus.yml`

---

## Database Issues

### Problem: Database Connection Failed

**Symptoms:**
```
psycopg2.OperationalError: could not connect to server
Connection refused
```

**Diagnostic Commands:**
```bash
# Check database container
docker ps | grep postgres

# Test connection from app VM
docker exec flask-app psql -h 192.168.56.12 -U postgres -d app_db

# Check database logs
docker logs app-database
```

**Solutions:**
1. **Verify database VM is running:**
   ```bash
   vagrant status database
   ```

2. **Check network connectivity:**
   ```bash
   ping 192.168.56.12
   ```

3. **Verify credentials:**
   ```python
   DB_CONFIG = {
       'host': '192.168.56.12',
       'database': 'app_db',
       'user': 'postgres',
       'password': 'secretpassword',
       'port': 5432
   }
   ```

**Related Files:**
- `chapter-6/production-lab/app-vm/app.py`
- `chapter-6/production-lab/database-vm/docker-compose.yml`

---

## General Diagnostics

### Quick Health Check Script

```bash
#!/bin/bash
# Quick health check for all services

echo "=== VM Status ==="
vagrant status

echo -e "\n=== Flask App ==="
curl -s http://localhost:5006/health | head -5 || echo "❌ Flask App DOWN"

echo -e "\n=== Database Proxy ==="
curl -s http://localhost:8081/health || echo "❌ Database Proxy DOWN"

echo -e "\n=== Prometheus ==="
curl -s http://localhost:9090/-/ready && echo "✅ Prometheus Ready" || echo "❌ Prometheus DOWN"

echo -e "\n=== Jenkins ==="
curl -s http://localhost:8086/login >/dev/null && echo "✅ Jenkins UP" || echo "❌ Jenkins DOWN"

echo -e "\n=== Port Conflicts ==="
lsof -i :5006 -i :3000 -i :9090 -i :8086 -i :8081 2>/dev/null || echo "No conflicts detected"
```

### Resource Check

```bash
# Check memory
free -h

# Check disk space
df -h

# Check CPU
top
# or
htop
```

### Network Check

```bash
# Check VM IPs
vagrant ssh VM_NAME -c "hostname -I"

# Test connectivity
ping 192.168.56.10
ping 192.168.56.11
ping 192.168.56.12

# Check port forwarding
vagrant port VM_NAME
```

---

## Getting More Help

### Documentation References
- [Port Reference Guide](PORT-REFERENCE.md)
- Chapter-specific README files
- Service-specific troubleshooting guides

### Common Solutions Summary
1. **Port conflicts**: Check with `lsof -i :PORT`, change port or kill process
2. **Docker issues**: Check service status, permissions, restart service
3. **VM issues**: Reload VM, check resources, verify virtualization
4. **Network issues**: Verify containers on same network, check DNS
5. **Service issues**: Check logs, verify configuration, restart service

### When to Start Over
If nothing works:
1. `vagrant destroy -f` (destroys all VMs)
2. `docker system prune -a -f` (cleans Docker)
3. `vagrant up` (fresh start)

**Remember**: Most issues are configuration-related. Check logs first, then verify configurations match the examples in the book.

