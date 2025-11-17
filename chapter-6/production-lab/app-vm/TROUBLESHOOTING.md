# Troubleshooting Guide - Production Lab Services

## Quick Service Status Check

Run this from your Mac terminal (not in VM):

```bash
cd ~/devops-pipeline/chapter-6/production-lab

# Check VM status
vagrant status

# Check services are accessible
curl http://localhost:5006/health
curl -s -o /dev/null -w "Grafana: %{http_code}\n" http://localhost:3000/api/health
curl -s -o /dev/null -w "Prometheus: %{http_code}\n" http://localhost:9090/-/ready
```

## Service URLs

### Flask Application
- **Root**: http://localhost:5006/
- **Health Check**: http://localhost:5006/health
- **Metrics**: http://localhost:5006/metrics
- **API Users**: http://localhost:5006/api/users
- **Stress Test**: http://localhost:5006/api/stress

### Grafana
- **Web UI**: http://localhost:3000
- **Login**: 
  - Username: `admin`
  - Password: `admin123`
- **Dashboard**: http://localhost:3000/d/flask-app-monitoring/flask-app-monitoring

### Prometheus
- **Web UI**: http://localhost:9090
- **Targets**: http://localhost:9090/targets
- **Graph**: http://localhost:9090/graph

## Common Issues

### Issue 1: "Connection Refused" on Port 5006

**Symptoms**: `curl: (7) Failed to connect to localhost port 5006: Connection refused`

**Solution**:
```bash
# SSH into app VM
vagrant ssh app

# Check if monitoring stack is running
cd ~/monitoring
docker-compose ps

# If not running, start it
docker-compose up -d

# Wait for services to start
sleep 15

# Verify containers are running
docker ps | grep -E "(flask-app|grafana|prometheus)"
```

**Expected output**: You should see all three containers running.

---

### Issue 2: Grafana Dashboard Not Showing

**Symptoms**: Can access Grafana but dashboard doesn't appear

**Solution**:
```bash
vagrant ssh app

# Check dashboard file exists
ls -la ~/monitoring/grafana-dashboards/

# Restart Grafana to reload dashboards
cd ~/monitoring
docker-compose restart grafana

# Wait a few seconds
sleep 10

# Check Grafana logs
docker logs grafana | grep -i dashboard | tail -10
```

**Verify dashboard exists**:
```bash
# From inside app VM
curl -u admin:admin123 http://localhost:3000/api/dashboards/uid/flask-app-monitoring
```

**Expected**: Should return JSON with dashboard information.

---

### Issue 3: Flask App Returns 404 on Root Path

**Symptoms**: `http://localhost:5006/` returns 404

**Current behavior**: The root path returns JSON with API information, not HTML.

**Test it**:
```bash
curl http://localhost:5006/
```

**Expected output**:
```json
{
  "name": "Flask App API",
  "version": "1.0.0",
  "endpoints": {
    "health": "/health",
    "users": "/api/users",
    "stress": "/api/stress",
    "metrics": "/metrics"
  }
}
```

**This is correct!** The app is working, it just returns JSON instead of HTML.

---

### Issue 4: Prometheus Can't Scrape Flask App

**Symptoms**: Prometheus targets show Flask app as "down"

**Check**:
```bash
vagrant ssh app

# Check if containers are on same network
docker network inspect monitoring_monitoring_network --format '{{range .Containers}}{{.Name}} {{end}}'
```

**Expected**: Should show `flask-app prometheus grafana`

**If not on same network**:
```bash
cd ~/monitoring
docker-compose down
docker-compose up -d
```

**Check Prometheus targets**:
```bash
# From your Mac
curl -s 'http://localhost:9090/api/v1/targets' | python3 -m json.tool | grep -A 5 "flask-app"
```

---

### Issue 5: Services Running But Not Accessible from Host

**Symptoms**: Containers are running but can't access from Mac browser

**Check port forwarding**:
```bash
# From your Mac
vagrant port app
```

**Expected output**:
```
5000 => 5006
3000 => 3000
9090 => 9090
```

**If ports don't match**, check Vagrantfile:
```bash
cat chapter-6/production-lab/Vagrantfile | grep -A 2 "app.vm.define"
```

**Fix**: Restart the VM to apply port forwarding:
```bash
vagrant reload app
```

---

## Restart All Services

If nothing works, restart everything:

```bash
# From your Mac
cd ~/devops-pipeline/chapter-6/production-lab

# Restart app VM
vagrant reload app

# Wait for VM to boot
sleep 30

# SSH and start services
vagrant ssh app -c "cd ~/monitoring && docker-compose up -d && sleep 15 && docker-compose ps"
```

---

## Verify Everything is Working

Run this complete check:

```bash
#!/bin/bash
echo "=== Service Health Check ==="
echo ""

echo "1. Flask App Health:"
curl -s http://localhost:5006/health | python3 -m json.tool 2>/dev/null || curl -s http://localhost:5006/health
echo ""

echo "2. Grafana Status:"
curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:3000/api/health
echo ""

echo "3. Prometheus Status:"
curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:9090/-/ready
echo ""

echo "4. Container Status:"
vagrant ssh app -c "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -E '(flask-app|grafana|prometheus|NAMES)'"
echo ""

echo "=== Access URLs ==="
echo "Flask App: http://localhost:5006/"
echo "Grafana: http://localhost:3000 (admin/admin123)"
echo "Dashboard: http://localhost:3000/d/flask-app-monitoring/flask-app-monitoring"
echo "Prometheus: http://localhost:9090"
```

Save this as `check-services.sh` and run: `chmod +x check-services.sh && ./check-services.sh`

---

## Still Having Issues?

1. **Check VM is running**: `vagrant status`
2. **Check Docker is running in VM**: `vagrant ssh app -c "sudo systemctl status docker"`
3. **Check container logs**: `vagrant ssh app -c "cd ~/monitoring && docker-compose logs --tail=50"`
4. **Check port conflicts**: `lsof -i :5006 -i :3000 -i :9090`

