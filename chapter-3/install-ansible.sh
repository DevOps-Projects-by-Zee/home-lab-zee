#!/bin/bash
# Ansible Installation Script

echo "=== Ansible Installation Guide ==="

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    echo "Installing Ansible via Homebrew..."
    
    if command -v brew &> /dev/null; then
        brew install ansible
    else
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Platform: Linux"
    echo "Installing Ansible..."
    
    if [[ $EUID -eq 0 ]]; then
        apt update
        apt install -y ansible
    else
        echo "Please run as root or with sudo:"
        echo "sudo apt update && sudo apt install -y ansible"
    fi
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Platform: Windows"
    echo "Installing Ansible in WSL..."
    echo "Run in WSL:"
    echo "sudo apt update && sudo apt install -y ansible"
    
else
    echo "Unknown platform: $OSTYPE"
    echo "Please install Ansible manually:"
    echo "https://docs.ansible.com/ansible/latest/installation_guide/"
fi

echo ""
echo "=== Verification ==="
echo "Verify installation:"
echo "ansible --version"
echo ""
echo "=== Test Connection ==="
echo "Test connection to servers:"
echo "ansible all -i inventory.ini -m ping"
echo ""
echo "=== Run Playbook ==="
echo "Deploy nginx to all servers:"
echo "ansible-playbook -i inventory.ini webserver.yml"
