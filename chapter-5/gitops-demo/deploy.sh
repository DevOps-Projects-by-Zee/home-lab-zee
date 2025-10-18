#!/bin/bash
# Simple deployment script

echo "=== Deploying application ==="

# Copy files to VM
vagrant upload app /home/vagrant/app

# Deploy on VM
vagrant ssh -c "cd /home/vagrant/app && docker-compose up -d"

echo "✅ Deployment complete! Visit http://localhost:8085"
