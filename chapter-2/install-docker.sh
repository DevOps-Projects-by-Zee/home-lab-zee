#!/bin/bash
# Docker Installation Script

echo "=== Docker Installation Guide ==="

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    echo "Download Docker Desktop from: https://www.docker.com/products/docker-desktop"
    echo "Install the .dmg file and start Docker Desktop"
    echo "Verify installation: docker --version"
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Platform: Linux"
    echo "Installing Docker..."
    
    # Download and install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    
    if [[ $EUID -eq 0 ]]; then
        sh get-docker.sh
        usermod -aG docker $USER
    else
        echo "Please run as root or with sudo:"
        echo "sudo sh get-docker.sh"
        echo "sudo usermod -aG docker $USER"
    fi
    
    # Clean up
    rm get-docker.sh
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Platform: Windows"
    echo "Download Docker Desktop from: https://www.docker.com/products/docker-desktop"
    echo "Run the installer and restart your computer"
    
else
    echo "Unknown platform: $OSTYPE"
    echo "Please download Docker manually from: https://www.docker.com/products/docker-desktop"
fi

echo ""
echo "=== Verification ==="
echo "Log out and back in, then verify installation:"
echo "docker --version"
echo ""
echo "=== First Container ==="
echo "Run your first container:"
echo "docker run -d -p 8080:80 --name web nginx"
echo "Visit: http://localhost:8080"
