#!/bin/bash
# Kubernetes Tools Installation Script

echo "=== Kubernetes Tools Installation ==="

# Detect platform
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Platform: macOS"
    echo "Installing kubectl and minikube via Homebrew..."
    
    if command -v brew &> /dev/null; then
        brew install kubectl minikube
    else
        echo "Homebrew not found. Please install Homebrew first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fi
    
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Platform: Linux"
    echo "Installing kubectl..."
    
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    
    if [[ $EUID -eq 0 ]]; then
        mv kubectl /usr/local/bin/
    else
        echo "Please run as root or with sudo:"
        echo "sudo mv kubectl /usr/local/bin/"
    fi
    
    # Install minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    
    if [[ $EUID -eq 0 ]]; then
        install minikube-linux-amd64 /usr/local/bin/minikube
    else
        echo "Please run as root or with sudo:"
        echo "sudo install minikube-linux-amd64 /usr/local/bin/minikube"
    fi
    
    # Clean up
    rm minikube-linux-amd64
    
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
    echo "Platform: Windows"
    echo "Installing via Chocolatey..."
    echo "Run PowerShell as Administrator and execute:"
    echo "choco install kubernetes-cli minikube"
    
else
    echo "Unknown platform: $OSTYPE"
    echo "Please download tools manually:"
    echo "kubectl: https://kubernetes.io/docs/tasks/tools/"
    echo "minikube: https://minikube.sigs.k8s.io/docs/start/"
fi

echo ""
echo "=== Verification ==="
echo "Verify installation:"
echo "kubectl version --client"
echo "minikube version"
echo ""
echo "=== Start Kubernetes Cluster ==="
echo "Start minikube:"
echo "minikube start --driver=docker"
echo ""
echo "=== Deploy Application ==="
echo "Deploy nginx:"
echo "kubectl apply -f nginx-deployment.yaml"
echo "kubectl get pods"
echo "minikube service nginx --url"
