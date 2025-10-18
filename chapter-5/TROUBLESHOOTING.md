# Chapter 5: Monitoring Stack Troubleshooting Guide

## Common Issues and Solutions

### 🚨 Port Conflicts
**Problem:** `Vagrant cannot forward the specified ports... already in use`

**Solution:**
```bash
# Check what's using the port
lsof -i :9090
lsof -i :3000

# Change ports in Vagrantfile
config.vm.network "forwarded_port", guest: 9090, host: 9091  # Prometheus
config.vm.network "forwarded_port", guest: 3000, host: 3001  # Grafana
```

### 🐳 Docker Installation Issues
**Problem:** `curl -fsSL https://get.docker.com | sh` fails on Ubuntu Focal

**Solution:**
```bash
# Use apt instead
sudo apt-get update
sudo apt-get install -y docker.io docker-compose
sudo systemctl start docker
sudo usermod -aG docker vagrant
```

### 📊 Prometheus Targets DOWN
**Problem:** Targets showing DOWN in Prometheus UI

**Solutions:**
```bash
# Check node_exporter status on app servers
vagrant ssh app1
sudo systemctl status node_exporter

# Restart node_exporter
sudo systemctl restart node_exporter

# Test metrics endpoint
curl http://localhost:9100/metrics

# Check network connectivity from monitor VM
vagrant ssh monitor
ping 192.168.56.61
curl http://192.168.56.61:9100/metrics
```

### 🔄 Container Conflicts
**Problem:** `Cannot create container for service prometheus: Conflict`

**Solution:**
```bash
# Clean up existing containers
vagrant ssh monitor
cd ~
docker-compose down
docker-compose up -d
```

### 🌐 Network Connectivity Issues
**Problem:** VMs can't communicate with each other

**Solutions:**
```bash
# Check VM networking
vagrant ssh monitor
ip addr show

# Test connectivity
ping 192.168.56.61
ping 192.168.56.62

# Check firewall (if any)
sudo ufw status
```

### 📁 File Upload Issues
**Problem:** `vagrant upload` fails

**Solution:**
```bash
# Specify VM name for multi-VM environment
vagrant upload docker-compose.yml /home/vagrant/ monitor
vagrant upload prometheus.yml /home/vagrant/ monitor
```

### 🔧 Docker Compose Version Issues
**Problem:** `Version in "./docker-compose.yml" is unsupported`

**Solution:**
```yaml
# Change from:
version: '3.8'
# To:
version: '3.3'  # Compatible with Ubuntu Focal's docker-compose
```

## Diagnostic Commands

### Check System Status
```bash
# VM status
vagrant status

# Docker containers
vagrant ssh monitor -c "docker ps"

# Node exporter status
vagrant ssh app1 -c "sudo systemctl status node_exporter"
vagrant ssh app2 -c "sudo systemctl status node_exporter"

# Network connectivity
vagrant ssh monitor -c "ping -c 3 192.168.56.61"
```

### Reset Everything
```bash
# Nuclear option
vagrant destroy -f
vagrant up
```

## Prevention Tips

✅ **Before starting:**
- Check port availability
- Ensure sufficient RAM (8GB+ recommended)
- Verify VirtualBox is running

✅ **During setup:**
- Test each step individually
- Verify network connectivity
- Check service status

✅ **After completion:**
- Test Prometheus targets
- Verify Grafana data source
- Import dashboard successfully

## Emergency Recovery

If everything breaks:

1. **Stop all VMs:** `vagrant destroy -f`
2. **Clean Docker:** `docker system prune -a`
3. **Restart VirtualBox**
4. **Start fresh:** `vagrant up`
5. **Follow setup steps one by one**

## Success Indicators

✅ **Prometheus:** http://localhost:9090 shows targets UP
✅ **Grafana:** http://localhost:3000 login works
✅ **Node Exporters:** Both app servers responding
✅ **Metrics:** CPU, memory, disk data visible
✅ **Dashboard:** Node Exporter dashboard imported

This monitoring stack is production-ready and used by major companies worldwide!
