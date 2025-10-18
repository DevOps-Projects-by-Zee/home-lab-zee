# Chapter 5: Complete Monitoring Stack

## Overview
This chapter demonstrates how to build a production-grade monitoring solution using Prometheus and Grafana to monitor multiple servers.

## What You'll Build
- **3 Virtual Machines**: 1 monitoring server + 2 app servers
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Node Exporter**: System metrics collection

## Files Included

### `Vagrantfile`
- Defines 3 VMs: monitor, app1, app2
- Installs node_exporter on app servers
- Sets up private networking (192.168.56.x)
- Port forwarding for Prometheus (9090) and Grafana (3000)

### `docker-compose.yml`
- Prometheus service configuration
- Grafana service configuration
- Volume mounts for data persistence
- Network configuration

### `prometheus.yml`
- Prometheus configuration
- Scrape targets (app1:9100, app2:9100)
- Scrape interval: 15 seconds
- Target labels for grouping

## Quick Start

1. **Start VMs:**
   ```bash
   vagrant up
   ```

2. **Install Docker on monitor VM:**
   ```bash
   vagrant ssh monitor
   sudo apt-get update
   sudo apt-get install -y docker.io docker-compose
   sudo systemctl start docker
   sudo usermod -aG docker vagrant
   exit
   ```

3. **Upload config files:**
   ```bash
   vagrant upload docker-compose.yml /home/vagrant/ monitor
   vagrant upload prometheus.yml /home/vagrant/ monitor
   ```

4. **Start monitoring stack:**
   ```bash
   vagrant ssh monitor
   cd ~
   docker-compose up -d
   ```

5. **Access services:**
   - **Prometheus:** http://localhost:9090
   - **Grafana:** http://localhost:3000 (admin/admin)

## What You'll See

### Prometheus Targets
- Status → Targets shows both app servers UP
- Real-time metrics collection every 15 seconds

### Grafana Dashboard
- Import dashboard ID: 1860 (Node Exporter)
- CPU, Memory, Disk, Network metrics
- Beautiful visualizations

## Architecture

```
Your Mac → Port 9090/3000 → Monitor VM → Prometheus/Grafana
                                    ↓
                              App1 (192.168.56.61:9100)
                              App2 (192.168.56.62:9100)
```

## Key Concepts Learned

- **Metrics Collection**: Node Exporter gathers system metrics
- **Time Series Database**: Prometheus stores metrics over time
- **Visualization**: Grafana creates dashboards and alerts
- **Service Discovery**: Automatic target detection
- **Production Monitoring**: Same tools used by Netflix, Uber, Google

## Cleanup
```bash
vagrant destroy -f
```

## Troubleshooting

- **Port conflicts**: Change port mappings in Vagrantfile
- **Docker issues**: Use `apt install docker.io` instead of Docker script
- **Container conflicts**: Run `docker-compose down` then `up -d`
- **Targets DOWN**: Check node_exporter service status

This is a complete monitoring solution that scales to thousands of servers!
