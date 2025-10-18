#!/bin/bash
# Quick Start Script for Chapter 1 Web Server VM

echo "=== Chapter 1: Virtualization Platform Setup ==="

# Check if we're in the right directory
if [ ! -f "Vagrantfile" ]; then
    echo "Vagrantfile not found. Please run this script from the chapter-1 directory."
    exit 1
fi

echo "Starting web server VM..."

# Destroy any existing VM
echo "Cleaning up any existing VMs..."
vagrant destroy -f

# Start the VM
echo "Starting new VM with web server..."
vagrant up

echo ""
echo "=== VM Started Successfully! ==="
echo ""
echo "Access your web server at: http://localhost:8080"
echo ""
echo "Useful commands:"
echo "  vagrant ssh     - Connect to VM"
echo "  vagrant halt    - Stop VM"
echo "  vagrant destroy - Delete VM"
echo "  vagrant status  - Check VM status"
echo ""
echo "If you get a port conflict error:"
echo "  lsof -i :8080   - Check what's using port 8080"
echo "  Edit Vagrantfile line 4 to use a different port"
