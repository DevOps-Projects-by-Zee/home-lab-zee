# Chapter 1: Your Virtualization Platform

## Overview
This chapter covers setting up your virtualization environment using either Proxmox (for spare hardware) or VirtualBox + Vagrant (universal solution).

## Files Included

### `Vagrantfile`
- Basic web server VM configuration
- Ubuntu 20.04 LTS (Focal)
- Nginx web server with custom page
- Port forwarding (VM port 80 → Host port 8080)

### `proxmox-setup.sh`
- Post-installation script for Proxmox VE
- Removes subscription nag
- Configures repositories
- Installs useful tools

### `install-virtualbox.sh`
- Platform-specific VirtualBox installation guide
- Supports macOS, Linux, and Windows
- Verification commands

### `install-vagrant.sh`
- Platform-specific Vagrant installation guide
- Supports macOS (Homebrew), Linux (deb package), Windows (Chocolatey)
- Verification commands

### `start-webserver.sh`
- Quick start script for the web server VM
- Handles cleanup and startup
- Provides useful commands and troubleshooting

## Quick Start

### Option 1: VirtualBox + Vagrant (Recommended)
```bash
# Install VirtualBox and Vagrant first
./install-virtualbox.sh
./install-vagrant.sh

# Start the web server VM
./start-webserver.sh

# Access your web server
open http://localhost:8080
```

### Option 2: Proxmox (Spare Hardware Only)
1. Download Proxmox VE ISO from https://www.proxmox.com/en/downloads
2. Create bootable USB and install on spare PC
3. Access web UI at https://192.168.1.100:8006
4. Run post-install script: `./proxmox-setup.sh`

## What You'll Learn

- **Virtualization Concepts**: VMs, hypervisors, resource allocation
- **Infrastructure as Code**: Vagrantfile configuration
- **Automation**: Shell provisioning scripts
- **Networking**: Port forwarding and VM communication
- **Web Servers**: Basic nginx setup and configuration

## Architecture

```
Your Computer → VirtualBox → Ubuntu VM → Nginx Web Server
     ↓              ↓           ↓            ↓
Port 8080 ←→ Port 80 ←→ Internal Network ←→ Web Content
```

## Troubleshooting

### Port Conflicts
```bash
# Check what's using port 8080
lsof -i :8080

# Change port in Vagrantfile
config.vm.network "forwarded_port", guest: 80, host: 8081
```

### VM Won't Start
```bash
# Check VirtualBox status
vboxmanage list runningvms

# Check Vagrant status
vagrant status

# Restart VM
vagrant reload
```

### Installation Issues
- **macOS**: Grant security permissions in System Preferences
- **Windows**: Run installers as Administrator
- **Linux**: Use sudo for package installation

## Useful Commands

```bash
vagrant up        # Start VM
vagrant halt      # Stop VM
vagrant destroy   # Delete VM
vagrant reload    # Restart VM
vagrant ssh       # Connect to VM
vagrant status    # Check VM status
```

## Next Steps

After completing Chapter 1, you'll have:
- ✅ Working virtualization platform
- ✅ Basic VM management skills
- ✅ Web server running in VM
- ✅ Understanding of port forwarding

Ready for Chapter 2: Infrastructure as Code with Terraform!
