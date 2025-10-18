# Chapter 4: Portfolio Projects

## Overview
This chapter contains two complete portfolio projects that demonstrate real-world DevOps scenarios: load balancing and monitoring.

## Projects Included

### Project 1: Load-Balanced Web App
**Location**: `project1/`
**What it does**: Demonstrates load balancing across multiple web servers

#### Files
- **`docker-compose.yml`** - Multi-container setup with load balancer
- **`nginx.conf`** - Load balancer configuration
- **`html/index.html`** - Web page content

#### Quick Start
```bash
cd project1
docker-compose up -d
# Visit http://localhost:8080
# Refresh to see load balancing
```

#### Architecture
```
Load Balancer (nginx) → Web1, Web2, Web3 (nginx containers)
```

### Project 2: Complete Monitoring Stack
**Location**: `project2/`
**What it does**: Full monitoring solution with Prometheus and Grafana

#### Files
- **`docker-compose.yml`** - Monitoring stack (Prometheus + Grafana + Node Exporter)
- **`prometheus.yml`** - Prometheus configuration

#### Quick Start
```bash
cd project2
docker-compose up -d
# Prometheus: http://localhost:9090
# Grafana: http://localhost:3000 (admin/admin)
```

#### Architecture
```
Node Exporter → Prometheus → Grafana Dashboard
```

## What You'll Learn

### Load Balancing
- **High Availability**: Multiple servers handling requests
- **Traffic Distribution**: Round-robin load balancing
- **Fault Tolerance**: Continue serving if one server fails
- **Scalability**: Easy to add more servers

### Monitoring
- **Metrics Collection**: System and application metrics
- **Data Storage**: Time-series database (Prometheus)
- **Visualization**: Dashboards and alerts (Grafana)
- **Observability**: Complete system visibility

## Project Details

### Project 1: Load Balancing
- **3 Web Servers**: Each serving the same content
- **Load Balancer**: Distributes requests evenly
- **Health Checks**: Automatic failover
- **Session Persistence**: Optional sticky sessions

### Project 2: Monitoring
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Node Exporter**: System metrics (CPU, memory, disk)
- **Alerting**: Configurable alerts and notifications

## Verification

### Load Balancing Test
```bash
# Test load balancing
curl http://localhost:8080
curl http://localhost:8080
curl http://localhost:8080
# Should show different server hostnames
```

### Monitoring Verification
1. **Prometheus**: Visit http://localhost:9090
   - Go to Status → Targets
   - Verify node-exporter is UP
2. **Grafana**: Visit http://localhost:3000
   - Login: admin/admin
   - Add Prometheus datasource
   - Import dashboard ID: 1860

## Production Considerations

### Load Balancing
- **SSL Termination**: Add HTTPS support
- **Health Checks**: Implement proper health endpoints
- **Session Management**: Consider session persistence
- **Auto-scaling**: Scale based on load

### Monitoring
- **Alert Rules**: Define alerting thresholds
- **Retention**: Configure data retention policies
- **High Availability**: Run Prometheus in cluster mode
- **Security**: Implement authentication and authorization

## Cleanup
```bash
# Stop all services
docker-compose down

# Remove volumes (optional)
docker-compose down -v
```

## Next Steps
These projects demonstrate core DevOps concepts:
- **Infrastructure**: Container orchestration
- **Load Balancing**: High availability
- **Monitoring**: Observability and alerting
- **Automation**: Infrastructure as Code

Ready to build your own DevOps pipeline!
