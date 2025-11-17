# Network Architecture Reference

Complete network architecture and IP address reference for the DevOps Lab.

## 🌐 Network Overview

### Private Network Range

All VMs use the VirtualBox private network: **192.168.56.0/24**

```
192.168.56.0/24
├── 192.168.56.1    (Host machine gateway)
├── 192.168.56.10   (Jenkins VM - Chapter 6)
├── 192.168.56.11   (App VM - Chapter 6)
├── 192.168.56.12   (Database VM - Chapter 6)
├── 192.168.56.20   (Load Balancer - Chapter 5)
├── 192.168.56.50   (Monitor VM - Chapter 5)
├── 192.168.56.61   (App Server 1 - Chapter 5)
└── 192.168.56.62   (App Server 2 - Chapter 5)
```

---

## 📊 Chapter 5: Real-World Integration

### Network Layout

```
Host Machine (Your Laptop)
    │
    ├── Port 8080 → 192.168.56.20:80 (Load Balancer)
    ├── Port 8084 → k3d Cluster (Kubernetes)
    ├── Port 8085 → GitOps Demo
    ├── Port 9090 → 192.168.56.50:9090 (Prometheus)
    └── Port 3000 → 192.168.56.50:3000 (Grafana)
         │
         └── VirtualBox Network (192.168.56.0/24)
              │
              ├── 192.168.56.10 (web1)
              ├── 192.168.56.11 (web2)
              ├── 192.168.56.20 (lb - Load Balancer)
              ├── 192.168.56.50 (monitor - Monitoring Stack)
              ├── 192.168.56.61 (app1 - App Server)
              └── 192.168.56.62 (app2 - App Server)
```

### VM Details

| VM Name | IP Address | Services | Ports (Host) |
|---------|-----------|----------|--------------|
| web1 | 192.168.56.10 | nginx web server | - |
| web2 | 192.168.56.11 | nginx web server | - |
| lb | 192.168.56.20 | nginx load balancer | 8080 |
| monitor | 192.168.56.50 | Prometheus, Grafana | 9090, 3000 |
| app1 | 192.168.56.61 | Node Exporter | 9100 |
| app2 | 192.168.56.62 | Node Exporter | 9100 |

---

## 📊 Chapter 6: Production Environment

### Network Layout

```
Host Machine (Your Laptop)
    │
    ├── Port 8086 → 192.168.56.10:8080 (Jenkins)
    ├── Port 5006 → 192.168.56.11:5000 (Flask App)
    ├── Port 3000 → 192.168.56.11:3000 (Grafana)
    ├── Port 9090 → 192.168.56.11:9090 (Prometheus)
    ├── Port 8081 → 192.168.56.12:80 (Database Proxy)
    └── Port 5432 → 192.168.56.12:5432 (PostgreSQL)
         │
         └── VirtualBox Network (192.168.56.0/24)
              │
              ├── 192.168.56.10 (jenkins - CI/CD Server)
              ├── 192.168.56.11 (app - Application + Monitoring)
              └── 192.168.56.12 (database - Database + Proxy)
```

### VM Details

| VM Name | IP Address | Services | Ports (VM) | Ports (Host) |
|---------|-----------|----------|------------|--------------|
| jenkins | 192.168.56.10 | Jenkins CI/CD | 8080 | 8086 |
| app | 192.168.56.11 | Flask App, Prometheus, Grafana | 5000, 9090, 3000 | 5006, 9090, 3000 |
| database | 192.168.56.12 | PostgreSQL, nginx Proxy | 5432, 80 | 5432, 8081 |

### Service Communication

```
┌─────────────────┐
│  Jenkins VM     │
│  192.168.56.10  │
│  Port: 8080     │
└─────────────────┘
         │
         │ (Can SSH to other VMs)
         │
         ▼
┌─────────────────┐      ┌─────────────────┐
│  App VM         │◄─────┤  Database VM     │
│  192.168.56.11  │      │  192.168.56.12   │
│                 │      │                 │
│  Flask App      │      │  PostgreSQL     │
│  Port: 5000     │      │  Port: 5432      │
│                 │      │                 │
│  Prometheus     │      │  nginx Proxy    │
│  Port: 9090     │      │  Port: 80       │
│                 │      └─────────────────┘
│  Grafana        │
│  Port: 3000     │
└─────────────────┘
```

---

## 🔌 Port Forwarding Reference

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

### Chapter 6 Port Forwarding

| Service | Guest Port | Host Port | Access URL |
|---------|-----------|-----------|------------|
| Jenkins | 8080 | 8086 | http://localhost:8086 |
| Flask App | 5000 | 5006 | http://localhost:5006 |
| Prometheus | 9090 | 9090 | http://localhost:9090 |
| Grafana | 3000 | 3000 | http://localhost:3000 |
| Database Proxy | 80 | 8081 | http://localhost:8081 |
| PostgreSQL | 5432 | 5432 | localhost:5432 |

---

## 🌍 Service Discovery

### Docker Network (Chapter 6)

Containers on the same Docker network can communicate by service name:

```
┌─────────────────────────────────────────┐
│  Docker Network: monitoring_network     │
│                                         │
│  ┌──────────────┐  ┌──────────────┐    │
│  │ flask-app    │  │ prometheus  │   │
│  │ (5000)       │  │ (9090)       │   │
│  └──────────────┘  └──────────────┘    │
│         │                  │            │
│         └──────────────────┘            │
│    Can communicate by name              │
└─────────────────────────────────────────┘
```

**Example:**
- Prometheus can reach Flask app at `http://flask-app:5000`
- Flask app can reach database at `192.168.56.12:5432` (different VM)

---

## 🔍 Network Troubleshooting

### Test Connectivity

**From Host to VM:**
```bash
# Test VM is reachable
ping 192.168.56.10

# Test service on VM
curl http://192.168.56.10:8080
```

**From VM to VM:**
```bash
# SSH into VM
vagrant ssh app

# Test connectivity to other VM
ping 192.168.56.12
curl http://192.168.56.12:80
```

**From Container to Container:**
```bash
# Test service discovery
docker exec CONTAINER nslookup SERVICE_NAME
docker exec CONTAINER wget http://SERVICE_NAME:PORT
```

### Check Network Configuration

**Vagrant:**
```bash
vagrant port VM_NAME          # Show forwarded ports
vagrant ssh-config VM_NAME    # Show SSH config
```

**Docker:**
```bash
docker network ls             # List networks
docker network inspect NET    # Network details
docker inspect CONTAINER      # Container network info
```

**VM Network:**
```bash
# Inside VM
ip addr                        # Network interfaces
ip route                       # Routing table
netstat -tuln                 # Listening ports
```

---

## 📋 IP Address Allocation

### Reserved IPs

| IP Range | Purpose | Used By |
|----------|---------|---------|
| 192.168.56.1 | Host gateway | VirtualBox |
| 192.168.56.2-9 | Reserved | - |
| 192.168.56.10 | Jenkins | Chapter 6 |
| 192.168.56.11 | App Server | Chapter 6 |
| 192.168.56.12 | Database | Chapter 6 |
| 192.168.56.13-19 | Available | - |
| 192.168.56.20 | Load Balancer | Chapter 5 |
| 192.168.56.21-49 | Available | - |
| 192.168.56.50 | Monitor | Chapter 5 |
| 192.168.56.51-60 | Available | - |
| 192.168.56.61 | App Server 1 | Chapter 5 |
| 192.168.56.62 | App Server 2 | Chapter 5 |
| 192.168.56.63-254 | Available | - |

---

## 🔐 Security Notes

### Network Isolation

- VMs are on private network (192.168.56.0/24)
- Not accessible from internet
- Only accessible from host machine
- Safe for experimentation

### Firewall Considerations

**macOS:**
- Usually no firewall issues
- May need to allow VirtualBox in System Preferences

**Windows:**
- May need to allow VirtualBox in Windows Firewall
- VirtualBox creates network adapters automatically

**Linux:**
- May need to configure firewall rules
- Usually works out of the box

---

## 📊 Network Diagrams

### Chapter 5: Complete Architecture

```
                    Host Machine
                         │
        ┌────────────────┼────────────────┐
        │                │                │
    Port 8080      Port 8084      Port 9090/3000
        │                │                │
        ▼                ▼                ▼
   Load Balancer    Kubernetes      Monitoring
   (192.168.56.20)   (k3d)         (192.168.56.50)
        │                │                │
        ├────────────────┼────────────────┤
        │                │                │
        ▼                ▼                ▼
   Web Servers      Apps            Node Exporters
   (10, 11)         (Pods)         (61, 62)
```

### Chapter 6: Production Architecture

```
                    Host Machine
                         │
        ┌────────────────┼────────────────┐
        │                │                │
    Port 8086      Port 5006      Port 8081
        │                │                │
        ▼                ▼                ▼
     Jenkins          App VM         Database VM
  (192.168.56.10)  (192.168.56.11) (192.168.56.12)
        │                │                │
        │                ├────────────────┤
        │                │                │
        │                ▼                ▼
        │          Flask App         PostgreSQL
        │          Prometheus        nginx Proxy
        │          Grafana
        │
        └──────────► Can deploy to App VM
```

---

## 🛠️ Network Configuration Examples

### Vagrantfile Network Config

```ruby
# Private network (recommended)
config.vm.network "private_network", ip: "192.168.56.10"

# Port forwarding
config.vm.network "forwarded_port", guest: 8080, host: 8086

# Public network (not recommended for lab)
# config.vm.network "public_network"
```

### Docker Network Config

```yaml
# docker-compose.yml
services:
  app:
    networks:
      - app_network
  
  prometheus:
    networks:
      - app_network

networks:
  app_network:
    driver: bridge
```

---

## 📝 Quick Reference

### Access Services

**From Host:**
- Use `localhost:HOST_PORT` (e.g., `http://localhost:8086`)
- Or use VM IP directly (e.g., `http://192.168.56.10:8080`)

**From VM:**
- Use VM IP (e.g., `http://192.168.56.12:80`)
- Or use service name if on same Docker network

**From Container:**
- Use service name (e.g., `http://flask-app:5000`)
- Or use VM IP for external services (e.g., `http://192.168.56.12:5432`)

---

**📖 Related:**
- [Port Reference](../PORT-REFERENCE.md)
- [Command Reference](COMMAND-REFERENCE.md)
- [Troubleshooting Guide](../TROUBLESHOOTING-INDEX.md)

