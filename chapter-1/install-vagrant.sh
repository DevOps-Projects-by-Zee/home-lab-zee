#!/bin/bash
# Vagrant Installation Script for Different Platforms

echo "=== Vagrant Installation Guide ==="

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    echo "Installing Vagrant via Homebrew..."
    
    # Check if Homebrew is installed
    if command -v brew &> /dev/null; then
        brew install vagrant
    else
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        echo "Then run: brew install vagrant"
    fi
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Platform: Linux"
    echo "Installing Vagrant..."
    
    # Download Vagrant package
    wget https://releases.hashicorp.com/vagrant/2.4.1/vagrant_2.4.1-1_amd64.deb
    
    # Install package
    if [[ $EUID -eq 0 ]]; then
        dpkg -i vagrant_2.4.1-1_amd64.deb
    else
        echo "Please run as root or with sudo:"
        echo "sudo dpkg -i vagrant_2.4.1-1_amd64.deb"
    fi
    
    # Clean up
    rm vagrant_2.4.1-1_amd64.deb
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Platform: Windows"
    echo "Installing Vagrant via Chocolatey..."
    echo "Run PowerShell as Administrator and execute:"
    echo "choco install vagrant"
    
else
    echo "Unknown platform: $OSTYPE"
    echo "Please download Vagrant manually from: https://www.vagrantup.com/downloads"
fi

echo ""
echo "=== Verification ==="
echo "Restart your terminal and verify installation:"
echo "vagrant --version"
echo ""
echo "=== Next Steps ==="
echo "1. Create a lab directory: mkdir ~/lab && cd ~/lab"
echo "2. Initialize Vagrant: vagrant init ubuntu/focal64"
echo "3. Start your first VM: vagrant up"
