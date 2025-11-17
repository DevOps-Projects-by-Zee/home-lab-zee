# Prerequisites & Installation Guide

This document provides comprehensive installation instructions for all software required throughout the DevOps Lab curriculum.

## 📋 Installation Checklist

Before starting any chapter, ensure you have:

- [ ] VirtualBox installed and working
- [ ] Vagrant installed and working
- [ ] Docker installed and working
- [ ] 10GB+ free disk space
- [ ] 8GB+ RAM available
- [ ] Virtualization enabled in BIOS
- [ ] Stable internet connection

---

## 🖥️ System Requirements

### Minimum Requirements
- **RAM**: 8GB (16GB recommended)
- **Disk Space**: 50GB free (100GB recommended)
- **CPU**: 64-bit processor with virtualization support
- **OS**: macOS 10.15+, Windows 10+, or Linux (Ubuntu 20.04+)

### Virtualization Support
Virtualization must be enabled in your BIOS/UEFI settings.

**Check if enabled:**
- **macOS**: `sysctl -a | grep VMX` (should show VMX)
- **Linux**: `egrep -c '(vmx|svm)' /proc/cpuinfo` (should be > 0)
- **Windows**: `systeminfo | findstr "Hyper-V"` (should show enabled)

---

## 📦 Software Installation

### 1. VirtualBox

**Purpose:** Virtualization platform for running VMs

**Installation:**

**macOS:**
```bash
# Download from https://www.virtualbox.org/wiki/Downloads
# Or use Homebrew:
brew install --cask virtualbox
```

**Windows:**
- Download installer from https://www.virtualbox.org/wiki/Downloads
- Run installer, accept network adapter warning
- Restart computer if prompted

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install virtualbox -y
```

**Verify:**
```bash
vboxmanage --version
# Expected: 7.0.x or higher
```

**📖 Detailed guide: [chapter-1/install-virtualbox.sh](chapter-1/install-virtualbox.sh)**

---

### 2. Vagrant

**Purpose:** VM management and automation

**Installation:**

**macOS:**
```bash
brew install vagrant
```

**Windows (PowerShell as Admin):**
```powershell
choco install vagrant
```

**Linux (Ubuntu/Debian):**
```bash
wget https://releases.hashicorp.com/vagrant/2.4.1/vagrant_2.4.1-1_amd64.deb
sudo dpkg -i vagrant_2.4.1-1_amd64.deb
```

**Verify:**
```bash
vagrant --version
# Expected: Vagrant 2.4.x or higher
```

**📖 Detailed guide: [chapter-1/install-vagrant.sh](chapter-1/install-vagrant.sh)**

---

### 3. Docker

**Purpose:** Container platform

**Installation:**

**macOS/Windows:**
- Download Docker Desktop from https://www.docker.com/products/docker-desktop
- Install and start Docker Desktop
- Grant necessary permissions

**Linux (Ubuntu/Debian):**
```bash
# Install using convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in for group changes
newgrp docker
```

**Verify:**
```bash
docker --version
# Expected: Docker version 20.10.x or higher

docker run hello-world
# Should pull and run test container
```

**📖 Detailed guide: [chapter-2/install-docker.sh](chapter-2/install-docker.sh)**

---

### 4. kubectl (Kubernetes CLI)

**Purpose:** Kubernetes command-line tool

**Installation:**

**macOS:**
```bash
brew install kubectl
```

**Windows (PowerShell):**
```powershell
choco install kubernetes-cli
```

**Linux:**
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

**Verify:**
```bash
kubectl version --client
# Should show version information
```

**📖 Detailed guide: [chapter-2/install-k8s-tools.sh](chapter-2/install-k8s-tools.sh)**

---

## 🔧 Chapter-Specific Prerequisites

### Chapter 2: Kubernetes Options

**Option A: Minikube (Mac/Windows/Linux)**
```bash
# macOS
brew install minikube

# Windows
choco install minikube

# Linux
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

**Option B: MicroK8s (Linux Only)**
```bash
sudo snap install microk8s --classic --channel=1.29/stable
sudo usermod -aG microk8s $USER
newgrp microk8s
```

**📖 See [Chapter 2](chapter-2/README.md) or [Chapter 2B](chapter-2b/README.md) for details**

---

### Chapter 3: Infrastructure as Code

**Terraform:**
```bash
# macOS
brew install terraform

# Windows
choco install terraform

# Linux
wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
unzip terraform_1.6.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

**Ansible:**
```bash
# macOS
brew install ansible

# Windows (WSL)
sudo apt install ansible

# Linux
sudo apt install ansible
```

**📖 See [Chapter 3](chapter-3/README.md) for detailed installation**

---

## ✅ Verification Steps

### 1. Check All Installations

Run this script to verify everything is installed:

```bash
echo "=== Checking Prerequisites ==="
echo "VirtualBox: $(vboxmanage --version 2>/dev/null || echo 'NOT INSTALLED')"
echo "Vagrant: $(vagrant --version 2>/dev/null || echo 'NOT INSTALLED')"
echo "Docker: $(docker --version 2>/dev/null || echo 'NOT INSTALLED')"
echo "kubectl: $(kubectl version --client 2>/dev/null | head -1 || echo 'NOT INSTALLED')"
```

### 2. Test Docker

```bash
docker run hello-world
```

Expected: Container runs and prints "Hello from Docker!"

### 3. Test Vagrant

```bash
mkdir ~/test-vagrant && cd ~/test-vagrant
vagrant init ubuntu/focal64
vagrant up
vagrant destroy -f
cd .. && rmdir test-vagrant
```

Expected: VM creates, starts, and destroys successfully

---

## 🚨 Common Installation Issues

### VirtualBox Installation Fails

**macOS:**
- System Preferences → Security & Privacy → Allow VirtualBox
- May need to disable System Integrity Protection (SIP) temporarily

**Windows:**
- Run installer as Administrator
- Disable Hyper-V if conflicting: `bcdedit /set hypervisorlaunchtype off`

**Linux:**
- Install kernel headers: `sudo apt install linux-headers-$(uname -r)`
- Add user to vboxusers group: `sudo usermod -aG vboxusers $USER`

### Docker Installation Fails

**Linux:**
- Use package manager instead of script:
  ```bash
  sudo apt update
  sudo apt install docker.io docker-compose
  ```

**Permission Errors:**
```bash
sudo usermod -aG docker $USER
newgrp docker  # Or log out and back in
```

### Vagrant Box Download Fails

**Solution:**
- Check internet connection
- Try manual download: `vagrant box add ubuntu/focal64`
- Use proxy if behind corporate firewall

---

## 📊 Resource Usage

### Expected Resource Consumption

| Component | RAM | Disk | CPU |
|-----------|-----|------|-----|
| Single VM | 1-2GB | 5-10GB | 1 core |
| Docker Desktop | 2GB | 5GB | Minimal |
| Minikube | 2GB | 5GB | 1 core |
| Full Lab (3 VMs) | 6-8GB | 30GB | 3 cores |

### Resource Management Tips

1. **Stop unused VMs**: `vagrant halt` when not using
2. **Clean Docker**: `docker system prune -a -f` regularly
3. **Remove old boxes**: `vagrant box remove BOX_NAME`
4. **Monitor resources**: Use `htop` or Activity Monitor

---

## 🔄 Updates & Maintenance

### Keeping Software Updated

**VirtualBox:**
- Check: https://www.virtualbox.org/wiki/Downloads
- macOS: `brew upgrade --cask virtualbox`
- Windows: Download new installer
- Linux: `sudo apt upgrade virtualbox`

**Vagrant:**
- macOS: `brew upgrade vagrant`
- Windows: `choco upgrade vagrant`
- Linux: Download new .deb package

**Docker:**
- macOS/Windows: Docker Desktop auto-updates
- Linux: `sudo apt upgrade docker.io`

---

## 📝 Next Steps

After completing prerequisites:

1. ✅ Verify all installations work
2. ✅ Test Docker with hello-world
3. ✅ Test Vagrant with a simple VM
4. ✅ Proceed to [Chapter 1](chapter-1/README.md)

---

## 🆘 Still Having Issues?

1. Check [TROUBLESHOOTING-INDEX.md](../TROUBLESHOOTING-INDEX.md)
2. Verify system requirements
3. Check virtualization is enabled
4. Review error messages carefully
5. Search GitHub issues for similar problems

---

**Ready?** → Start with [Chapter 1: Virtualization](chapter-1/README.md) 🚀

