# Port Reference Guide

## Overview
This document provides a comprehensive reference for all ports used throughout the DevOps Pipeline curriculum. Use this guide to avoid port conflicts and quickly identify which services use which ports.

## Quick Port Lookup

| Port | Service | Chapter | Guest Port | Host Port | Access URL |
|------|---------|---------|------------|-----------|------------|
| **8080** | Load Balancer | Chapter 5 | 80 | 8080 | http://localhost:8080 |
| **8081** | Database Proxy (nginx) | Chapter 6 | 80 | 8081 | http://localhost:8081 |
| **8084** | Kubernetes (k3d) | Chapter 5 | 8080 | 8084 | http://localhost:8084 |
| **8085** | GitOps Demo | Chapter 5 | 8080 | 8085 | http://localhost:8085 |
| **8086** | Jenkins | Chapter 6 | 8080 | 8086 | http://localhost:8086 |
| **3000** | Grafana | Chapters 5, 6 | 3000 | 3000 | http://localhost:3000 |
| **30080** | Kubernetes NodePort | Chapter 2B | 30080 | 30080 | http://localhost:30080 |
| **5000** | Flask App (internal) | Chapter 6 | 5000 | - | http://192.168.56.11:5000 |
| **5001** | Flask App (broken) | Chapter 6 | 5000 | 5001 | http://localhost:5001 |
| **5002** | Flask App (fixed) | Chapter 6 | 5000 | 5002 | http://localhost:5002 |
| **5006** | Flask App (production) | Chapter 6 | 5000 | 5006 | http://localhost:5006 |
| **5432** | PostgreSQL | Chapter 6 | 5432 | 5432 | localhost:5432 |
| **6443** | Kubernetes API | Chapter 5 | 6443 | 6443 | https://localhost:6443 |
| **9090** | Prometheus | Chapters 5, 6 | 9090 | 9090 | http://localhost:9090 |
| **9091** | Prometheus (broken) | Chapter 6 | 9090 | 9091 | http://localhost:9091 |
| **9092** | Prometheus (fixed) | Chapter 6 | 9090 | 9092 | http://localhost:9092 |
| **9100** | Node Exporter | Chapter 5 | 9100 | 9100 | http://localhost:9100 |

## Port Reference by Chapter

### Chapter 1: Virtualization
| Port | Service | Description |
|------|---------|-------------|
| 8080 | Web Server | Basic nginx web server (VM port 80 → Host port 8080) |

### Chapter 2: Containers
| Port | Service | Description |
|------|---------|-------------|
| 8080 | Docker Container | nginx container (default) |
| 30080 | Kubernetes NodePort | MicroK8s NodePort service |

### Chapter 2B: MicroK8s
| Port | Service | Description |
|------|---------|-------------|
| 30080 | Kubernetes NodePort | Nginx service NodePort |
| 10443 | Kubernetes Dashboard | Dashboard proxy (HTTPS) |

### Chapter 3: Infrastructure as Code
| Port | Service | Description |
|------|---------|-------------|
| 8080 | Terraform Container | Docker container created by Terraform |

### Chapter 4: Portfolio Projects
| Port | Service | Description |
|------|---------|-------------|
| 8080 | Load Balancer | Multi-container load-balanced app |
| 9090 | Prometheus | Monitoring stack |
| 3000 | Grafana | Monitoring dashboards |
| 9100 | Node Exporter | System metrics |

### Chapter 5: Real-World Integration
| Port | Service | Description |
|------|---------|-------------|
| 8080 | Load Balancer | Terraform + Ansible pipeline |
| 8084 | Kubernetes (k3d) | k3d cluster applications |
| 8085 | GitOps Demo | Automated deployment demo |
| 9090 | Prometheus | Monitoring lab |
| 3000 | Grafana | Monitoring lab |
| 9100 | Node Exporter | App server metrics |

### Chapter 6: Production Environment
| Port | Service | Description |
|------|---------|-------------|
| 8086 | Jenkins | CI/CD server (VM:8080 → Host:8086) |
| 5006 | Flask App | Web application (VM:5000 → Host:5006) |
| 3000 | Grafana | Monitoring dashboards |
| 9090 | Prometheus | Metrics collection |
| 8081 | Database Proxy | Nginx reverse proxy (VM:80 → Host:8081) |
| 5432 | PostgreSQL | Database server |
| 5001 | Flask (broken) | Debugging scenario - broken config |
| 5002 | Flask (fixed) | Debugging scenario - fixed config |
| 9091 | Prometheus (broken) | Debugging scenario - broken config |
| 9092 | Prometheus (fixed) | Debugging scenario - fixed config |

## Port Conflict Resolution

### How to Check if a Port is in Use

**macOS/Linux:**
```bash
lsof -i :PORT_NUMBER
# Example: lsof -i :8080
```

**Windows:**
```powershell
netstat -ano | findstr :PORT_NUMBER
# Example: netstat -ano | findstr :8080
```

### How to Resolve Port Conflicts

1. **Find what's using the port:**
   ```bash
   lsof -i :8080
   ```

2. **Kill the process (if safe to do so):**
   ```bash
   kill -9 $(lsof -ti:8080)
   ```

3. **Or change the port in your configuration:**
   - Edit `Vagrantfile` to use a different host port
   - Edit `docker-compose.yml` to use a different port mapping
   - Edit service configuration files

### Common Port Conflicts

| Port | Common Conflicts | Solution |
|------|------------------|----------|
| 8080 | macOS ControlCenter, other web servers | Use 8086, 8084, or 8085 |
| 5000 | macOS AirPlay Receiver | Use 5006 or 5002 |
| 3000 | React dev server, other Node apps | Use 3001 or check if Grafana is running |
| 5432 | Local PostgreSQL instance | Stop local PostgreSQL or use different port |
| 9090 | Other Prometheus instances | Use 9091 or 9092 |

## Port Forwarding Reference

### Understanding Port Forwarding

Port forwarding maps a port on your host machine to a port inside a VM:

```
Host Port → Guest Port (VM)
localhost:8086 → VM:8080
```

### Vagrant Port Forwarding Syntax

```ruby
config.vm.network "forwarded_port", guest: 8080, host: 8086
```

- **guest**: Port inside the VM
- **host**: Port on your Mac/PC

### Direct VM Access (No Port Forwarding)

You can also access services directly via the VM's private network IP:

```
http://192.168.56.10:8080  # Jenkins VM
http://192.168.56.11:5000  # App VM
http://192.168.56.12:80    # Database VM
```

## Service-Specific Port Details

### Jenkins (Chapter 6)
- **VM Port**: 8080
- **Host Port**: 8086
- **Agent Port**: 50000 (internal, not forwarded)
- **Access**: http://localhost:8086
- **Why different port**: Avoids conflict with other services

### Flask Application (Chapter 6)
- **VM Port**: 5000
- **Host Port**: 5006
- **Health Check**: http://localhost:5006/health
- **API**: http://localhost:5006/api/users
- **Why different port**: macOS AirPlay uses port 5000

### Grafana (Chapters 5, 6)
- **VM Port**: 3000
- **Host Port**: 3000
- **Default Credentials**: admin/admin123
- **Access**: http://localhost:3000
- **Note**: Check for conflicts with React dev servers

### Prometheus (Chapters 5, 6)
- **VM Port**: 9090
- **Host Port**: 9090 (or 9091/9092 for debugging)
- **Access**: http://localhost:9090
- **Targets**: http://localhost:9090/targets

### PostgreSQL (Chapter 6)
- **VM Port**: 5432
- **Host Port**: 5432
- **Connection String**: `postgresql://postgres:secretpassword@192.168.56.12:5432/app_db`
- **Note**: Only accessible from within VM network or via forwarded port

### Kubernetes Services

#### k3d (Chapter 5)
- **API Port**: 6443
- **App Port**: 8084 (LoadBalancer)
- **Access**: http://localhost:8084

#### MicroK8s (Chapter 2B)
- **NodePort**: 30080
- **Dashboard**: 10443 (HTTPS)
- **Access**: http://localhost:30080 or http://192.168.56.10:30080

## Port Ranges by Purpose

### Web Services (8000-8999)
- 8080: Load balancers, web servers
- 8081: Database proxy
- 8084: Kubernetes apps
- 8085: GitOps demo
- 8086: Jenkins

### Application Services (5000-5999)
- 5000: Flask app (internal)
- 5001: Flask (debugging - broken)
- 5002: Flask (debugging - fixed)
- 5006: Flask (production)
- 5432: PostgreSQL

### Monitoring Services (9000-9999)
- 9090: Prometheus (default)
- 9091: Prometheus (debugging - broken)
- 9092: Prometheus (debugging - fixed)
- 9100: Node Exporter

### Dashboard Services (3000-3999)
- 3000: Grafana
- 30080: Kubernetes NodePort

### System Services
- 6443: Kubernetes API (HTTPS)
- 10443: Kubernetes Dashboard (HTTPS)

## Quick Troubleshooting Commands

### Check All Ports in Use
```bash
# macOS/Linux
lsof -i -P -n | grep LISTEN

# Windows
netstat -ano | findstr LISTENING
```

### Check Specific Port
```bash
lsof -i :8080
```

### Find Port by Process
```bash
# macOS/Linux
lsof -i -P -n | grep PROCESS_NAME

# Windows
netstat -ano | findstr PROCESS_NAME
```

### Check Vagrant Port Forwarding
```bash
vagrant port VM_NAME
# Example: vagrant port jenkins
```

### Check Docker Container Ports
```bash
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

## Port Planning Tips

1. **Document your ports**: Keep a list of ports you're using
2. **Use high ports**: Avoid well-known ports (1-1024) when possible
3. **Check before starting**: Always verify ports are free before starting services
4. **Use consistent patterns**: Use port ranges for related services
5. **Document conflicts**: Note any port conflicts you encounter

## Port Reference by VM IP

### 192.168.56.10 (Jenkins VM)
- 8080: Jenkins web UI
- 30080: Kubernetes NodePort (if using MicroK8s)

### 192.168.56.11 (App VM)
- 5000: Flask application
- 3000: Grafana
- 9090: Prometheus

### 192.168.56.12 (Database VM)
- 80: Nginx reverse proxy
- 5432: PostgreSQL

### 192.168.56.20 (Load Balancer - Chapter 5)
- 80: Nginx load balancer

### 192.168.56.50 (Monitor VM - Chapter 5)
- 9090: Prometheus
- 3000: Grafana

### 192.168.56.61-62 (App Servers - Chapter 5)
- 9100: Node Exporter

## Summary

This port reference guide helps you:
- ✅ Quickly identify which ports are used by which services
- ✅ Avoid port conflicts before they happen
- ✅ Resolve conflicts when they occur
- ✅ Understand port forwarding configurations
- ✅ Access services correctly

**Remember**: When in doubt, check what's using a port with `lsof -i :PORT` (macOS/Linux) or `netstat -ano | findstr :PORT` (Windows).

