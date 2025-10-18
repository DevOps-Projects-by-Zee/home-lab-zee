#!/bin/bash
# Proxmox Post-Install Setup Script
# Run this after installing Proxmox VE

echo "=== Proxmox Post-Install Setup ==="

# Remove subscription nag
echo "Removing subscription nag..."
sed -i.backup "s/data.status !== 'Active'/false/g" /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js
systemctl restart pveproxy

# Fix repositories
echo "Configuring repositories..."
echo "# deb https://enterprise.proxmox.com/debian/pve bookworm pve-enterprise" > /etc/apt/sources.list.d/pve-enterprise.list
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-no-subscription.list

# Update system
echo "Updating system packages..."
apt update && apt dist-upgrade -y

# Install useful tools
echo "Installing additional tools..."
apt install -y htop vim curl wget

echo "=== Setup Complete! ==="
echo "Proxmox is ready to use."
echo "Access web UI at: https://192.168.1.100:8006"
echo "Login: root / (your password)"
