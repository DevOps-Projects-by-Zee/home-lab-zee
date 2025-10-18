#!/bin/bash
# Terraform Installation Script

echo "=== Terraform Installation Guide ==="

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    echo "Installing Terraform via Homebrew..."
    
    if command -v brew &> /dev/null; then
        brew install terraform
    else
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Platform: Linux"
    echo "Installing Terraform..."
    
    # Download Terraform
    wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
    unzip terraform_1.6.0_linux_amd64.zip
    
    if [[ $EUID -eq 0 ]]; then
        mv terraform /usr/local/bin/
    else
        echo "Please run as root or with sudo:"
        echo "sudo mv terraform /usr/local/bin/"
    fi
    
    # Clean up
    rm terraform_1.6.0_linux_amd64.zip
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Platform: Windows"
    echo "Installing via Chocolatey..."
    echo "Run PowerShell as Administrator and execute:"
    echo "choco install terraform"
    
else
    echo "Unknown platform: $OSTYPE"
    echo "Please download Terraform manually from: https://www.terraform.io/downloads"
fi

echo ""
echo "=== Verification ==="
echo "Verify installation:"
echo "terraform --version"
echo ""
echo "=== First Infrastructure ==="
echo "Initialize Terraform:"
echo "terraform init"
echo ""
echo "Plan changes:"
echo "terraform plan"
echo ""
echo "Apply changes:"
echo "terraform apply"
echo ""
echo "Destroy resources:"
echo "terraform destroy"
