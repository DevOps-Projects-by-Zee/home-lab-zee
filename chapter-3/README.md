# Chapter 3: Infrastructure as Code

## Overview
This chapter covers Infrastructure as Code (IaC) using Terraform and Ansible, teaching you how to automate infrastructure provisioning and configuration management.

## Files Included

### Terraform Files
- **`main.tf`** - Terraform configuration for Docker container
- **`install-terraform.sh`** - Cross-platform Terraform installation script

### Ansible Files
- **`inventory.ini`** - Server inventory file
- **`webserver.yml`** - Ansible playbook for nginx installation
- **`install-ansible.sh`** - Cross-platform Ansible installation script

## Quick Start

### Terraform
```bash
# Install Terraform
./install-terraform.sh

# Initialize and deploy
terraform init
terraform plan
terraform apply

# Access application
open http://localhost:8080

# Clean up
terraform destroy
```

### Ansible
```bash
# Install Ansible
./install-ansible.sh

# Test connection
ansible all -i inventory.ini -m ping

# Deploy nginx
ansible-playbook -i inventory.ini webserver.yml
```

## What You'll Learn

- **Infrastructure as Code**: Define infrastructure in code
- **Terraform**: Provision infrastructure declaratively
- **Ansible**: Configure servers with playbooks
- **State Management**: Track infrastructure changes
- **Automation**: Repeatable deployments

## Architecture

### Terraform
```
Terraform → Docker Provider → Docker Container → Nginx Web Server
```

### Ansible
```
Ansible Controller → SSH → Target Servers → nginx Installation
```

## Essential Commands

### Terraform
```bash
terraform init        # Initialize providers
terraform plan        # Preview changes
terraform apply       # Apply changes
terraform destroy     # Remove resources
terraform show        # Show current state
```

### Ansible
```bash
ansible all -i inventory.ini -m ping              # Test connection
ansible-playbook -i inventory.ini webserver.yml   # Run playbook
ansible all -i inventory.ini -m shell -a "uptime" # Run commands
```

## Configuration Details

### Terraform Provider
- **Provider**: Docker (kreuzwerker/docker)
- **Resources**: Image + Container
- **Port Mapping**: 8080 → 80

### Ansible Playbook
- **Target**: webservers group
- **Tasks**: Install nginx, start service
- **Privilege**: become: yes (sudo)

## Troubleshooting

- **Docker not running**: Start Docker Desktop
- **SSH connection issues**: Check inventory.ini IPs and SSH keys
- **Permission errors**: Ensure proper sudo access

Ready for Chapter 4: Portfolio Projects!
