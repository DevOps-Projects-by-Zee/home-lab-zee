# Chapter 6: Production Environment Simulation

## Overview
This chapter builds a complete, realistic production environment across 3 virtual machines. You'll experience real infrastructure challenges, debugging scenarios, and learn production-grade DevOps skills - all without cloud costs.

## What You're Building

A multi-tier production environment that simulates real-world infrastructure:

- **VM1: Jenkins CI/CD Server** (2GB RAM)
  - Jenkins automation server
  - Git integration
  - Docker builds
  - Pipeline orchestration

- **VM2: Application + Monitoring** (4GB RAM)
  - Flask web application
  - Prometheus metrics collection
  - Grafana dashboards
  - Container networking debugging

- **VM3: Database + Reverse Proxy** (2GB RAM)
  - PostgreSQL database
  - Nginx reverse proxy
  - Load balancing
  - Health checks

## Why This Matters

This setup teaches you:
- **Real debugging skills**: Network issues, service discovery, container communication
- **Production patterns**: Multi-VM architecture, monitoring, CI/CD
- **Troubleshooting methodology**: Systematic problem-solving approach
- **Infrastructure understanding**: How services communicate across VMs

## Project Structure

```
chapter-6/production-lab/
├── Vagrantfile                    # Defines 3 VMs
├── jenkins-vm/
│   ├── docker-compose.yml        # Jenkins setup
│   ├── JENKINS-SETUP.md          # Detailed Jenkins guide
│   └── Push-to-github-steps.md  # Git integration guide
├── app-vm/
│   ├── app.py                    # Flask application
│   ├── Dockerfile                # Application container
│   ├── docker-compose.yml        # Monitoring stack
│   ├── prometheus.yml            # Prometheus config
│   ├── alert_rules.yml           # Alert definitions
│   ├── requirements.txt          # Python dependencies
│   ├── grafana-dashboards/      # Grafana dashboards
│   ├── grafana-datasources/     # Prometheus datasource
│   ├── debugging/                # Container networking lab
│   └── TROUBLESHOOTING.md        # Quick troubleshooting
└── database-vm/
    ├── docker-compose.yml        # PostgreSQL + Nginx
    ├── init-db.sql              # Database schema
    └── nginx.conf               # Reverse proxy config
```

## Quick Start

### 1. Start All VMs
```bash
cd chapter-6/production-lab
vagrant up
```

**This takes 8-12 minutes** (creating 3 VMs + installing Docker)

### 2. Verify VMs Are Running
```bash
vagrant status
```

Expected output:
```
jenkins                   running (virtualbox)
app                       running (virtualbox)
database                  running (virtualbox)
```

### 3. Set Up Database Server (VM3)
```bash
vagrant ssh database
cd ~/database-setup
docker-compose up -d
```

### 4. Set Up Application + Monitoring (VM2)
```bash
vagrant ssh app
cd ~/monitoring
docker-compose up -d
```

### 5. Set Up Jenkins (VM1)
```bash
vagrant ssh jenkins
cd ~/jenkins-setup
docker-compose up -d
```

### 6. Access Services

| Service | URL | Credentials |
|---------|-----|-------------|
| Flask App | http://localhost:5006 | - |
| Flask Health | http://localhost:5006/health | - |
| Grafana | http://localhost:3000 | admin/admin123 |
| Prometheus | http://localhost:9090 | - |
| Jenkins | http://localhost:8086 | See JENKINS-SETUP.md |
| Database Proxy | http://localhost:8081/health | - |

## Network Architecture

```
Your Mac
    ↓
┌─────────────────────────────────────────┐
│  Private Network: 192.168.56.0/24      │
├─────────────────────────────────────────┤
│                                         │
│  VM1: Jenkins (192.168.56.10)          │
│  ├── Jenkins:8080 → localhost:8086     │
│  └── Git, Docker builds                 │
│                                         │
│  VM2: App + Monitoring (192.168.56.11) │
│  ├── Flask:5000 → localhost:5006       │
│  ├── Grafana:3000 → localhost:3000     │
│  └── Prometheus:9090 → localhost:9090 │
│                                         │
│  VM3: Database (192.168.56.12)         │
│  ├── PostgreSQL:5432 → localhost:5432 │
│  └── Nginx:80 → localhost:8081        │
└─────────────────────────────────────────┘
```

## Step-by-Step Guide

### Step 1: VM Infrastructure Setup
- Create 3 VMs with Vagrant
- Configure private networking
- Install Docker on all VMs
- Set up port forwarding

**Files**: `Vagrantfile`

### Step 2: Database Server Setup
- Deploy PostgreSQL database
- Configure Nginx reverse proxy
- Set up database schema
- Test database connectivity

**Files**: `database-vm/docker-compose.yml`, `database-vm/init-db.sql`, `database-vm/nginx.conf`

### Step 3: Flask Application Setup
- Create Flask web application
- Add Prometheus metrics
- Configure health checks
- Connect to database

**Files**: `app-vm/app.py`, `app-vm/Dockerfile`, `app-vm/requirements.txt`

### Step 4: Monitoring Stack Setup
- Configure Prometheus
- Set up Grafana dashboards
- Create alert rules
- Verify metrics collection

**Files**: `app-vm/prometheus.yml`, `app-vm/alert_rules.yml`, `app-vm/grafana-dashboards/`

### Step 5: Container Networking Debugging
- Experience real networking problems
- Debug service discovery issues
- Fix container communication
- Learn systematic troubleshooting

**Files**: `app-vm/debugging/docker-compose-broken.yml`, `app-vm/debugging/docker-compose-fixed.yml`

**Guide**: See `app-vm/debugging/DEBUGGING-GUIDE.md` (if exists)

### Step 6: Jenkins CI/CD Setup
- Install and configure Jenkins
- Create pipeline jobs
- Set up Git integration
- Build and deploy applications

**Files**: `jenkins-vm/docker-compose.yml`, `jenkins-vm/JENKINS-SETUP.md`

### Step 7: Jenkins Pipeline Integration
- Create infrastructure health check pipeline
- Test application functionality
- Verify network connectivity
- Run performance smoke tests

**Files**: Pipeline scripts in Jenkins

## Key Learning Objectives

### Infrastructure Skills
- Multi-VM architecture design
- Private network configuration
- Service discovery and DNS
- Load balancing and reverse proxying

### Container Skills
- Docker Compose multi-container apps
- Container networking and isolation
- Service-to-service communication
- Health checks and monitoring

### Monitoring Skills
- Prometheus metrics collection
- Grafana dashboard creation
- Alert rule configuration
- Performance analysis

### CI/CD Skills
- Jenkins pipeline creation
- Automated testing
- Infrastructure health checks
- Deployment automation

### Debugging Skills
- Systematic troubleshooting methodology
- Network connectivity testing
- Service discovery debugging
- Container log analysis

## Common Scenarios

### Scenario 1: Container Networking Issue
**Problem**: Prometheus can't scrape Flask app metrics
**Symptoms**: Target shows "DOWN" in Prometheus
**Debug**: Check container networks, DNS resolution, service names
**Solution**: Ensure containers are on the same Docker network

**Practice**: Complete the debugging session in `app-vm/debugging/`

### Scenario 2: Database Connection Failure
**Problem**: Flask app can't connect to PostgreSQL
**Symptoms**: Health check shows database as "unhealthy"
**Debug**: Check network connectivity, credentials, firewall
**Solution**: Verify database VM is running and accessible

### Scenario 3: Jenkins Build Failure
**Problem**: Pipeline fails during Docker build
**Symptoms**: Build logs show Docker daemon errors
**Debug**: Check Docker socket mounting, permissions
**Solution**: Ensure Docker socket is properly mounted in Jenkins

### Scenario 4: High Response Time
**Problem**: Application responds slowly
**Symptoms**: Grafana shows high response time metrics
**Debug**: Check resource usage, database queries, network latency
**Solution**: Optimize queries, increase resources, check for bottlenecks

## Troubleshooting

### Quick Status Checks
```bash
# Check all VMs
vagrant status

# Check Flask app
curl http://localhost:5006/health

# Check database proxy
curl http://localhost:8081/health

# Check Prometheus
curl http://localhost:9090/-/ready

# Check Jenkins
curl http://localhost:8086/login
```

### Container Status
```bash
# In app VM
vagrant ssh app
docker ps
docker-compose ps

# In database VM
vagrant ssh database
docker ps

# In Jenkins VM
vagrant ssh jenkins
docker ps
```

### Common Issues

**Port conflicts**: Check what's using ports with `lsof -i :PORT`
**VMs won't start**: Check VirtualBox, RAM availability
**Containers unhealthy**: Check logs with `docker logs CONTAINER_NAME`
**Network issues**: Verify VM IPs and port forwarding
**Resource constraints**: Check memory/CPU with `free -h` and `htop`

**Detailed troubleshooting**: See `app-vm/TROUBLESHOOTING.md`

## Accessing Services from Your Mac

### Direct Access (Recommended)
- Flask App: `http://192.168.56.11:5000` (from VM's private IP)
- Database Proxy: `http://192.168.56.12:80`

### Port Forwarding (If direct access doesn't work)
Ports are already forwarded in Vagrantfile:
- Flask: VM port 5000 → Host port 5006
- Grafana: VM port 3000 → Host port 3000
- Prometheus: VM port 9090 → Host port 9090
- Jenkins: VM port 8080 → Host port 8086
- Database Proxy: VM port 80 → Host port 8081

Access via `http://localhost:PORT`

### Kubernetes Services (If using MicroK8s)
For services deployed via MicroK8s NodePort:
- Access via VM's private IP: `http://192.168.56.10:30080`
- Or add port forwarding to Vagrantfile:
  ```ruby
  jenkins.vm.network "forwarded_port", guest: 30080, host: 30080
  ```
- Then access via: `http://localhost:30080`

## What Makes This Production-Like

### Real Challenges
- **Network isolation**: Containers on different networks can't communicate
- **Service discovery**: DNS resolution between containers
- **Resource constraints**: Limited RAM/CPU in VMs
- **Port conflicts**: Multiple services competing for ports
- **Configuration errors**: Misconfigured services fail silently

### Production Patterns
- **Multi-tier architecture**: Separate VMs for different concerns
- **Health checks**: Every service has a health endpoint
- **Monitoring**: Prometheus + Grafana for observability
- **CI/CD**: Automated testing and deployment
- **Infrastructure as Code**: Vagrantfiles define everything

### Debugging Skills
- **Systematic approach**: Test individual services → communication → network
- **Real tools**: `curl`, `nslookup`, `docker inspect`, `kubectl`
- **Log analysis**: Reading container and service logs
- **Network inspection**: Understanding Docker networks and DNS

## Portfolio Value

This project demonstrates:
- ✅ Multi-VM infrastructure design
- ✅ Container orchestration and networking
- ✅ Monitoring and observability
- ✅ CI/CD pipeline implementation
- ✅ Real-world troubleshooting skills
- ✅ Production-grade patterns

**Interview talking points:**
- "I built a complete production environment simulation with 3 VMs..."
- "I debugged container networking issues using systematic methodology..."
- "I implemented monitoring with Prometheus and Grafana..."
- "I created CI/CD pipelines that test infrastructure health..."

## Cleanup

### Stop All VMs
```bash
vagrant halt
```

### Destroy Everything
```bash
vagrant destroy -f
```

### Free Up Disk Space
```bash
# Clean Docker
docker system prune -a -f

# Remove Vagrant boxes (optional)
vagrant box list
vagrant box remove ubuntu/focal64
```

## Next Steps

After completing this chapter:
1. **Expand the lab**: Add more services, implement service mesh
2. **Advanced monitoring**: Add logging (ELK stack), tracing (Jaeger)
3. **Security**: Add SSL/TLS, implement secrets management
4. **Kubernetes**: Deploy k3s across VMs for orchestration
5. **Documentation**: Create runbooks for common scenarios
6. **Portfolio**: Document everything in GitHub with screenshots

## Resources

- **Jenkins Setup**: `jenkins-vm/JENKINS-SETUP.md`
- **Troubleshooting**: `app-vm/TROUBLESHOOTING.md`
- **Debugging Guide**: `app-vm/debugging/DEBUGGING-GUIDE.md` (if exists)
- **Git Integration**: `jenkins-vm/Push-to-github-steps.md`

## Time Investment

- **Initial Setup**: 4-6 hours
- **Learning & Experimentation**: Weeks of valuable practice
- **Cost**: $0 (runs on your laptop)
- **Value**: Production-ready DevOps skills

This is the most comprehensive project in the book - you'll gain real-world experience with the exact tools and patterns used in production environments!

