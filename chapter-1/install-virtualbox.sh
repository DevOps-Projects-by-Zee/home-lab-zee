#!/bin/bash
# VirtualBox Installation Script for Different Platforms

echo "=== VirtualBox Installation Guide ==="

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    echo "Download VirtualBox from: https://www.virtualbox.org/wiki/Downloads"
    echo "Install the .dmg file and grant security permissions in System Preferences"
    echo "Verify installation: vboxmanage --version"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Platform: Linux"
    echo "Installing VirtualBox via package manager..."
    
    # Check if running as root
    if [[ $EUID -eq 0 ]]; then
        apt update
        apt install -y virtualbox
    else
        echo "Please run as root or with sudo:"
        echo "sudo apt update && sudo apt install -y virtualbox"
    fi
    
    echo "Verify installation: vboxmanage --version"
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Platform: Windows"
    echo "Download VirtualBox from: https://www.virtualbox.org/wiki/Downloads"
    echo "Run the installer and accept the network warning"
    echo "Verify installation: vboxmanage --version"
    
else
    echo "Unknown platform: $OSTYPE"
    echo "Please download VirtualBox manually from: https://www.virtualbox.org/wiki/Downloads"
fi

echo ""
echo "=== Next Steps ==="
echo "1. Install Vagrant"
echo "2. Create your first VM with: vagrant init ubuntu/focal64"
echo "3. Start VM with: vagrant up"
