# Build Your Own DevOps Lab
## The Zero-Cost Infrastructure Guide

> **Virtual Box • Vagrant • Proxmox • Docker • Kubernetes • Terraform • Ansible**

Complete setups, automation scripts, and real portfolio projects—no cloud bills required.

A practical guide for engineers who want production-ready skills without burning money on AWS.

---

## 📚 Quick Navigation

- [🚀 Getting Started](#-getting-started)
- [📖 Table of Contents](#-table-of-contents)
- [🔧 Prerequisites](#-prerequisites)
- [📋 Quick Reference](#-quick-reference)
- [🗺️ Learning Path](#️-learning-path)
- [🌐 Port Reference](#-port-reference)
- [❓ Troubleshooting](#-troubleshooting)

---

## 🚀 Getting Started

### Choose Your Path

**New to DevOps?** → Start with [Chapter 1: Virtualization](chapter-1/README.md)

**Already know VMs?** → Jump to [Chapter 2: Containers](chapter-2/README.md)

**Want Kubernetes?** → See [Chapter 2B: MicroK8s](chapter-2b/README.md) (Linux) or [Chapter 2: Minikube](chapter-2/README.md) (Mac/Windows)

**Ready for Production?** → Go to [Chapter 6: Production Environment](chapter-6/README.md)

### System Requirements

- **Minimum**: 8GB RAM, 50GB disk space, Virtualization enabled
- **Recommended**: 16GB RAM, 100GB disk space
- **Platform**: Mac, Windows, or Linux

### Installation Checklist

Before starting, ensure you have:

- [ ] VirtualBox installed ([Install Guide](chapter-1/install-virtualbox.sh))
- [ ] Vagrant installed ([Install Guide](chapter-1/install-vagrant.sh))
- [ ] Docker installed ([Install Guide](chapter-2/install-docker.sh))
- [ ] 10GB+ free disk space
- [ ] Stable internet connection

**📖 See [PREREQUISITES.md](docs/PREREQUISITES.md) for detailed installation instructions.**

---

## 📖 Table of Contents

### Core Chapters

| Chapter | Topic | Time | Difficulty | Files |
|---------|-------|------|------------|-------|
| [Chapter 1](chapter-1/README.md) | Virtualization Platform | 1-2 hours | Beginner | [Files](chapter-1/) |
| [Chapter 2](chapter-2/README.md) | Containers (Docker + K8s) | 2-3 hours | Intermediate | [Files](chapter-2/) |
| [Chapter 2B](chapter-2b/README.md) | MicroK8s (Linux Native) | 1-2 hours | Intermediate | [Files](chapter-2b/) |
| [Chapter 3](chapter-3/README.md) | Infrastructure as Code | 2-3 hours | Intermediate | [Files](chapter-3/) |
| [Chapter 4](chapter-4/README.md) | Portfolio Projects | 3-4 hours | Intermediate | [Files](chapter-4/) |
| [Chapter 5](chapter-5/README.md) | Real-World Integration | 4-6 hours | Advanced | [Files](chapter-5/) |
| [Chapter 6](chapter-6/README.md) | Production Environment | 6-8 hours | Advanced | [Files](chapter-6/) |

### Reference Documents

- [📋 Port Reference](PORT-REFERENCE.md) - All ports used in the lab
- [🔧 Command Reference](docs/COMMAND-REFERENCE.md) - Quick command lookup
- [🌐 Network Architecture](docs/NETWORK-ARCHITECTURE.md) - Network diagrams and IPs
- [❓ Troubleshooting Guide](TROUBLESHOOTING-INDEX.md) - Common issues and solutions
- [📝 Prerequisites](docs/PREREQUISITES.md) - Installation requirements

---

## 🗺️ Learning Path

### Recommended Progression

```
Chapter 1: Virtualization
    ↓
Chapter 2: Containers (Choose Minikube OR MicroK8s)
    ↓
Chapter 3: Infrastructure as Code
    ↓
Chapter 4: Portfolio Projects
    ↓
Chapter 5: Real-World Integration
    ↓
Chapter 6: Production Environment
```

### Alternative Paths

**Fast Track (Skip Basics):**
- Chapter 1 (quick review) → Chapter 3 → Chapter 6

**Kubernetes Focus:**
- Chapter 2B (MicroK8s) → Chapter 5 (k3d) → Chapter 6

**Monitoring Focus:**
- Chapter 2 → Chapter 4 (Project 2) → Chapter 5 (Monitoring Lab) → Chapter 6

---

## 🔧 Prerequisites

### Required Software

| Software | Version | Platform | Install Guide |
|----------|---------|----------|---------------|
| VirtualBox | 7.0+ | All | [Install](chapter-1/install-virtualbox.sh) |
| Vagrant | 2.4+ | All | [Install](chapter-1/install-vagrant.sh) |
| Docker | 20.10+ | All | [Install](chapter-2/install-docker.sh) |
| kubectl | Latest | All | [Install](chapter-2/install-k8s-tools.sh) |

### Optional (Chapter-Specific)

| Software | Chapter | Install Guide |
|----------|---------|---------------|
| Terraform | Chapter 3 | [Install](chapter-3/install-terraform.sh) |
| Ansible | Chapter 3 | [Install](chapter-3/install-ansible.sh) |
| Minikube | Chapter 2 | [Install](chapter-2/install-k8s-tools.sh) |
| MicroK8s | Chapter 2B | See [Chapter 2B](chapter-2b/README.md) |

**📖 Full prerequisites: [PREREQUISITES.md](docs/PREREQUISITES.md)**

---

## 📋 Quick Reference

### Essential Commands

**Vagrant:**
```bash
vagrant up          # Start VMs
vagrant halt        # Stop VMs
vagrant destroy     # Delete VMs
vagrant ssh VM_NAME # Connect to VM
vagrant status      # Check VM status
```

**Docker:**
```bash
docker ps                    # List running containers
docker-compose up -d         # Start services
docker-compose down          # Stop services
docker logs CONTAINER        # View logs
```

**Kubernetes:**
```bash
kubectl get pods             # List pods
kubectl get services         # List services
kubectl apply -f FILE        # Deploy from file
kubectl logs POD_NAME        # View logs
```

**📖 Full command reference: [COMMAND-REFERENCE.md](docs/COMMAND-REFERENCE.md)**

---

## 🌐 Port Reference

### Common Ports

| Port | Service | Chapter | URL |
|------|---------|---------|-----|
| 8080 | Load Balancer | 5 | http://localhost:8080 |
| 8086 | Jenkins | 6 | http://localhost:8086 |
| 5006 | Flask App | 6 | http://localhost:5006 |
| 3000 | Grafana | 5, 6 | http://localhost:3000 |
| 9090 | Prometheus | 5, 6 | http://localhost:9090 |
| 8081 | Database Proxy | 6 | http://localhost:8081 |

**📖 Complete port reference: [PORT-REFERENCE.md](PORT-REFERENCE.md)**

---

## 🏗️ What You'll Build

### Complete Infrastructure Stack

```
┌─────────────────────────────────────────────────────────┐
│  PRODUCTION-READY DEVOPS PIPELINE                      │
│  ┌─────────────────────────────────────────────────┐   │
│  │  ✅ Virtualization (Vagrant/VirtualBox)        │   │
│  │  ✅ Container Orchestration (Docker/K8s)       │   │
│  │  ✅ Infrastructure as Code (Terraform/Ansible)  │   │
│  │  ✅ Monitoring (Prometheus/Grafana)             │   │
│  │  ✅ CI/CD (Jenkins)                             │   │
│  │  ✅ Load Balancing (nginx)                      │   │
│  │  ✅ Database (PostgreSQL)                       │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Portfolio Projects

1. **Load-Balanced Web App** - Multi-server architecture with nginx
2. **Complete Monitoring Stack** - Prometheus + Grafana + Node Exporter
3. **Kubernetes Cluster** - k3d or MicroK8s deployment
4. **GitOps Workflow** - Automated deployment pipeline
5. **Production Environment** - Full multi-VM setup with CI/CD

---

## ❓ Troubleshooting

### Quick Fixes

**Port conflicts:**
```bash
lsof -i :8080          # Check what's using port
kill -9 $(lsof -ti:8080)  # Kill process (if safe)
```

**VM won't start:**
```bash
vagrant reload         # Restart VM
vagrant destroy -f && vagrant up  # Rebuild
```

**Docker issues:**
```bash
docker system prune -a -f  # Clean up
sudo systemctl restart docker  # Restart Docker
```

**📖 Full troubleshooting: [TROUBLESHOOTING-INDEX.md](TROUBLESHOOTING-INDEX.md)**

---

## 📊 Architecture Overview

### System Architecture

```
Your Laptop (Host)
    ↓
VirtualBox Network (192.168.56.x)
    ↓
Virtual Machines
    ├── Jenkins VM (192.168.56.10)
    ├── App VM (192.168.56.11)
    └── Database VM (192.168.56.12)
        ↓
    Containers & Services
        ├── Docker Containers
        ├── Kubernetes Pods
        └── Monitoring Stack
```

**📖 Detailed architecture: [NETWORK-ARCHITECTURE.md](docs/NETWORK-ARCHITECTURE.md)**

---

## 🎯 Chapter Overview

### Chapter 1: Virtualization Platform
**Learn:** VirtualBox, Vagrant, VM management  
**Build:** Ubuntu VM with nginx web server  
**Time:** 1-2 hours  
**📖 [Read Chapter 1](chapter-1/README.md)**

### Chapter 2: Containers
**Learn:** Docker, Docker Compose, Kubernetes (Minikube)  
**Build:** Containerized applications, multi-container apps  
**Time:** 2-3 hours  
**📖 [Read Chapter 2](chapter-2/README.md)**

### Chapter 2B: MicroK8s (Linux Only)
**Learn:** Native Kubernetes on Linux  
**Build:** Production-grade K8s cluster  
**Time:** 1-2 hours  
**📖 [Read Chapter 2B](chapter-2b/README.md)**

### Chapter 3: Infrastructure as Code
**Learn:** Terraform, Ansible, automation  
**Build:** Automated infrastructure provisioning  
**Time:** 2-3 hours  
**📖 [Read Chapter 3](chapter-3/README.md)**

### Chapter 4: Portfolio Projects
**Learn:** Real-world project patterns  
**Build:** 2 complete projects (Load balancing, Monitoring)  
**Time:** 3-4 hours  
**📖 [Read Chapter 4](chapter-4/README.md)**

### Chapter 5: Real-World Integration
**Learn:** Combining all tools, advanced patterns  
**Build:** 4 integration projects  
**Time:** 4-6 hours  
**📖 [Read Chapter 5](chapter-5/README.md)**

### Chapter 6: Production Environment
**Learn:** Production debugging, CI/CD, monitoring  
**Build:** Complete 3-VM production setup  
**Time:** 6-8 hours  
**📖 [Read Chapter 6](chapter-6/README.md)**

---

## 💡 Tips for Success

1. **Follow the learning path** - Chapters build on each other
2. **Check prerequisites** - Install required software first
3. **Use port reference** - Avoid conflicts before they happen
4. **Read troubleshooting** - Common issues are documented
5. **Take breaks** - Some chapters take hours, that's normal
6. **Experiment** - Break things, then fix them (that's learning!)

---

## 🔗 Additional Resources

### Official Documentation
- [Docker Docs](https://docs.docker.com)
- [Kubernetes Docs](https://kubernetes.io/docs)
- [Terraform Docs](https://developer.hashicorp.com/terraform)
- [Ansible Docs](https://docs.ansible.com)
- [Vagrant Docs](https://www.vagrantup.com/docs)

### Community
- **GitHub Issues**: Report bugs or ask questions
- **Discussions**: Share your projects and learnings

---

## 📝 License & Credits

**Build Your Own DevOps Lab** © 2025 Zudonu Osomudeya

All rights reserved. See [LICENSE](LICENSE) for details.

**Author:**
- Email: zee@shipwithzee.com
- Website: shipwithzee.com
- LinkedIn: [osomudeya-zudonu](https://www.linkedin.com/in/osomudeya-zudonu-17290b124/)
- GitHub: [DevOps-Projects-by-Zee](https://github.com/DevOps-Projects-by-Zee/home-lab-zee)

---

## 🎉 Ready to Start?

1. ✅ Check [Prerequisites](docs/PREREQUISITES.md)
2. ✅ Install required software
3. ✅ Start with [Chapter 1](chapter-1/README.md)
4. ✅ Build your DevOps lab!

**Remember:** Your laptop was a datacenter all along. Let's build it! 🚀
