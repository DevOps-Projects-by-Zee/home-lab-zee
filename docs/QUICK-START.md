# Quick Start Guide

Get up and running with the DevOps Lab in 15 minutes.

## 🚀 Fastest Path to First Success

### Step 1: Install Prerequisites (5 minutes)

```bash
# Check what you need
./docs/PREREQUISITES.md

# Install VirtualBox
# macOS: brew install --cask virtualbox
# Windows: Download from virtualbox.org
# Linux: sudo apt install virtualbox

# Install Vagrant
# macOS: brew install vagrant
# Windows: choco install vagrant
# Linux: Download .deb from hashicorp.com

# Verify
vagrant --version
vboxmanage --version
```

### Step 2: Start Your First VM (5 minutes)

```bash
# Navigate to Chapter 1
cd chapter-1

# Start the VM
vagrant up

# Wait for it to boot (2-3 minutes)
# You'll see: "Machine booted and ready!"

# Access the web server
open http://localhost:8080
# Or: curl http://localhost:8080
```

**✅ Success!** You should see "Hello from Vagrant!"

### Step 3: Explore (5 minutes)

```bash
# SSH into the VM
vagrant ssh

# Inside the VM, check what's running
systemctl status nginx
curl http://localhost

# Exit
exit

# Stop the VM
vagrant halt
```

---

## 🎯 Choose Your Learning Path

### Path 1: Complete Beginner (Recommended)

```
Chapter 1 (VMs) → Chapter 2 (Docker) → Chapter 3 (IaC) → Chapter 4 (Projects)
```

**Time:** 8-12 hours  
**Result:** Complete DevOps foundation

### Path 2: Kubernetes Focus

```
Chapter 1 (quick) → Chapter 2B (MicroK8s) → Chapter 5 (k3d) → Chapter 6
```

**Time:** 6-10 hours  
**Result:** Kubernetes expertise

### Path 3: Production Ready

```
Chapter 1 → Chapter 2 → Chapter 6 (Production Environment)
```

**Time:** 10-14 hours  
**Result:** Production debugging skills

---

## 📋 Chapter Quick Starts

### Chapter 1: Virtualization

```bash
cd chapter-1
vagrant up
open http://localhost:8080
```

**Time:** 30 minutes  
**Result:** Running VM with web server

### Chapter 2: Containers

```bash
cd chapter-2
docker run -d -p 8080:80 --name web nginx
open http://localhost:8080
```

**Time:** 1 hour  
**Result:** Running Docker containers

### Chapter 3: Infrastructure as Code

```bash
cd chapter-3
terraform init
terraform apply
```

**Time:** 1-2 hours  
**Result:** Infrastructure defined in code

### Chapter 4: Portfolio Projects

```bash
cd chapter-4/project1
docker-compose up -d
open http://localhost:8080
```

**Time:** 2-3 hours  
**Result:** Load-balanced web app

### Chapter 5: Real-World Integration

```bash
cd chapter-5
vagrant up
# Follow chapter instructions
```

**Time:** 4-6 hours  
**Result:** Complete integrated pipeline

### Chapter 6: Production Environment

```bash
cd chapter-6/production-lab
vagrant up
# Follow chapter instructions
```

**Time:** 6-8 hours  
**Result:** Full production simulation

---

## ⚡ Common Quick Tasks

### Start All VMs

```bash
# From project root
vagrant up
```

### Check What's Running

```bash
# VMs
vagrant status

# Docker containers
docker ps

# Kubernetes pods
kubectl get pods
```

### Access Services

```bash
# Web servers
open http://localhost:8080

# Monitoring
open http://localhost:3000  # Grafana
open http://localhost:9090  # Prometheus

# Jenkins
open http://localhost:8086
```

### Stop Everything

```bash
# Stop VMs
vagrant halt

# Stop Docker containers
docker-compose down

# Stop Kubernetes
minikube stop  # or microk8s stop
```

### Clean Up

```bash
# Remove VMs
vagrant destroy -f

# Remove Docker resources
docker system prune -a -f

# Remove Kubernetes
minikube delete  # or microk8s reset
```

---

## 🎓 Learning Tips

### For Beginners

1. **Don't skip Chapter 1** - VMs are the foundation
2. **Follow in order** - Chapters build on each other
3. **Read error messages** - They tell you what's wrong
4. **Use troubleshooting guide** - Common issues are documented
5. **Take breaks** - Some chapters take hours

### For Experienced Users

1. **Skip to Chapter 6** - Most advanced content
2. **Use as reference** - Jump to specific topics
3. **Customize** - Modify configurations for your needs
4. **Experiment** - Break things, then fix them

---

## 🆘 Quick Troubleshooting

### VM Won't Start

```bash
vagrant reload
# If that fails:
vagrant destroy -f && vagrant up
```

### Port Already in Use

```bash
# Find what's using it
lsof -i :8080

# Kill it (if safe)
kill -9 $(lsof -ti:8080)

# Or change port in Vagrantfile
```

### Docker Issues

```bash
# Restart Docker
sudo systemctl restart docker  # Linux
# Or restart Docker Desktop (Mac/Windows)

# Clean up
docker system prune -a -f
```

### Out of Resources

```bash
# Check memory
free -h

# Check disk
df -h

# Stop unused VMs
vagrant halt
```

---

## 📚 Next Steps

After quick start:

1. ✅ Complete [Chapter 1](chapter-1/README.md) fully
2. ✅ Read [Prerequisites](docs/PREREQUISITES.md) for details
3. ✅ Bookmark [Command Reference](docs/COMMAND-REFERENCE.md)
4. ✅ Check [Port Reference](PORT-REFERENCE.md) before starting
5. ✅ Follow [Learning Path](#-choose-your-learning-path)

---

## 🎉 You're Ready!

Start with [Chapter 1](chapter-1/README.md) or jump to any chapter that interests you.

**Remember:** Take your time, experiment, and have fun building your DevOps lab! 🚀

