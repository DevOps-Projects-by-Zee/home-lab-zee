# DevOps Pipeline Infrastructure Diagram

## Complete Architecture Overview

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           DEVOPS PIPELINE CURRICULUM                            │
│                              Infrastructure Overview                             │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                CHAPTER 1                                        │
│                          Virtualization Platform                                │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Your Mac      │    │   VirtualBox    │    │   Ubuntu VM     │
│                 │    │                 │    │                 │
│ • macOS/Windows │───▶│ • Hypervisor    │───▶│ • Ubuntu 20.04  │
│ • Linux         │    │ • VM Manager    │    │ • nginx Server  │
│                 │    │                 │    │ • Port 8080     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Vagrant       │    │   Proxmox VE    │    │   Web Server    │
│                 │    │                 │    │                 │
│ • IaC Tool      │    │ • Bare Metal    │    │ • Hello World   │
│ • VM Provision  │    │ • Web UI        │    │ • Auto Deploy   │
│ • Port Forward  │    │ • Cluster Mgmt  │    │ • Custom Config │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                CHAPTER 2                                        │
│                              Containerization                                  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Docker        │    │ Docker Compose  │    │   Kubernetes    │
│                 │    │                 │    │                 │
│ • Container     │───▶│ • Multi-Container│───▶│ • Orchestration │
│ • Images        │    │ • Web + DB      │    │ • Minikube      │
│ • Port Mapping  │    │ • Networks      │    │ • Deployments   │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Custom App    │    │   App Stack     │    │   K8s Cluster   │
│                 │    │                 │    │                 │
│ • Dockerfile    │    │ • nginx:alpine  │    │ • 3x nginx Pods │
│ • Custom HTML   │    │ • postgres:15   │    │ • NodePort Svc  │
│ • Build Process │    │ • Shared Network│    │ • Load Balancing│
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                CHAPTER 3                                        │
│                          Infrastructure as Code                               │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Terraform     │    │   Ansible       │    │   Target VMs    │
│                 │    │                 │    │                 │
│ • IaC Tool      │───▶│ • Config Mgmt   │───▶│ • Web Servers   │
│ • Docker Prov.  │    │ • Playbooks     │    │ • nginx Install │
│ • State Mgmt    │    │ • SSH Access    │    │ • Service Start │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Resources     │    │   Inventory     │    │   Configured    │
│                 │    │                 │    │                 │
│ • Docker Image  │    │ • web1: 192.168 │    │ • nginx Running │
│ • Container     │    │ • web2: 192.168 │    │ • Port 80 Open  │
│ • Port Mapping  │    │ • SSH Keys      │    │ • Auto Start    │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                CHAPTER 4                                        │
│                            Portfolio Projects                                  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              PROJECT 1: Load Balancing                        │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Load Balancer │    │   Web Server 1  │    │   Web Server 2  │    │   Web Server 3  │
│                 │    │                 │    │                 │    │                 │
│ • nginx:alpine  │───▶│ • nginx:alpine  │    │ • nginx:alpine  │    │ • nginx:alpine  │
│ • Port 8080     │    │ • Same Content  │    │ • Same Content  │    │ • Same Content  │
│ • Round Robin   │    │ • Hostname: web1 │    │ • Hostname: web2 │    │ • Hostname: web3 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Client        │    │   Response 1    │    │   Response 2    │    │   Response 3    │
│                 │    │                 │    │                 │    │                 │
│ • Browser       │    │ • Server: web1  │    │ • Server: web2  │    │ • Server: web3  │
│ • http://8080   │    │ • Load Balanced │    │ • Load Balanced │    │ • Load Balanced │
│ • Refresh Test  │    │ • High Avail.   │    │ • High Avail.   │    │ • High Avail.   │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              PROJECT 2: Monitoring Stack                       │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Node Exporter │    │   Prometheus    │    │   Grafana       │
│                 │    │                 │    │                 │
│ • Metrics Coll. │───▶│ • Time Series   │───▶│ • Dashboards   │
│ • Port 9100     │    │ • Port 9090     │    │ • Port 3000     │
│ • System Stats  │    │ • Data Storage  │    │ • Visualization│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   System        │    │   Metrics       │    │   User          │
│                 │    │                 │    │                 │
│ • CPU Usage     │    │ • Scrape Config │    │ • Login: admin  │
│ • Memory Usage  │    │ • Retention     │    │ • Dashboard ID  │
│ • Disk I/O      │    │ • Query Engine  │    │ • Alert Rules   │
└─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                                CHAPTER 5                                        │
│                        Advanced DevOps Pipeline                                │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              COMPLETE PIPELINE                                 │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Terraform     │    │   Vagrant VMs   │    │   Ansible       │    │   Applications  │
│                 │    │                 │    │                 │    │                 │
│ • IaC Config    │───▶│ • web1, web2    │───▶│ • Config Mgmt   │───▶│ • Docker Apps   │
│ • Vagrantfile   │    │ • lb (load bal) │    │ • nginx Setup   │    │ • Load Balanced │
│ • Inventory     │    │ • Private Net   │    │ • Docker Install│    │ • Port Forward  │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   k3d Cluster   │    │   GitOps Demo   │    │   Monitoring    │    │   Production    │
│                 │    │                 │    │                 │    │                 │
│ • Kubernetes    │    │ • Auto Deploy   │    │ • Prometheus    │    │ • Real Apps     │
│ • LoadBalancer  │    │ • Version Ctrl  │    │ • Grafana       │    │ • High Avail.   │
│ • Port 8084     │    │ • Port 8085     │    │ • Node Exporters│    │ • Monitoring    │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              NETWORK TOPOLOGY                                  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│  Your Mac (Host) - Port Forwarding                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ Port 8080 → Load Balancer    Port 8081 → Load Balancer (Alt)            │   │
│  │ Port 8084 → k3d Cluster      Port 8085 → GitOps Demo                    │   │
│  │ Port 9090 → Prometheus       Port 3000 → Grafana                        │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│  VirtualBox Network (192.168.56.x)                                            │
│  ┌─────────────────────────────────────────────────────────────────────────┐   │
│  │ web1: 192.168.56.10    web2: 192.168.56.11    lb: 192.168.56.20        │   │
│  │ monitor: 192.168.56.50  app1: 192.168.56.61    app2: 192.168.56.62      │   │
│  └─────────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              DATA FLOW                                         │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Developer      │    │   Git Repo      │    │   CI/CD         │    │   Production    │
│                 │    │                 │    │                 │    │                 │
│ • Code Changes  │───▶│ • Version Ctrl  │───▶│ • Auto Deploy   │───▶│ • Live Apps     │
│ • Local Test    │    │ • GitOps        │    │ • Tests         │    │ • Monitoring    │
│ • Push Changes  │    │ • Branches      │    │ • Build         │    │ • Load Balance  │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              TECHNOLOGY STACK                                  │
└─────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Virtualization│    │   Containers    │    │   Orchestration │    │   Monitoring    │
│                 │    │                 │    │                 │    │                 │
│ • VirtualBox    │    │ • Docker        │    │ • Kubernetes   │    │ • Prometheus    │
│ • Vagrant       │    │ • Docker Compose│    │ • k3d          │    │ • Grafana       │
│ • Proxmox VE    │    │ • Images        │    │ • Minikube      │    │ • Node Exporter │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   IaC Tools     │    │   Web Servers   │    │   Load Balancing│    │   GitOps        │
│                 │    │                 │    │                 │    │                 │
│ • Terraform     │    │ • nginx         │    │ • nginx LB      │    │ • Git Workflow  │
│ • Ansible       │    │ • Alpine Linux │    │ • Round Robin   │    │ • Auto Deploy   │
│ • State Mgmt    │    │ • Port Forward  │    │ • Health Checks│    │ • Version Ctrl  │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────┐
│                              LEARNING PATH                                     │
└─────────────────────────────────────────────────────────────────────────────────┘

Chapter 1: Virtualization → Chapter 2: Containers → Chapter 3: IaC → Chapter 4: Projects → Chapter 5: Pipeline

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Foundation    │    │   Containerization│    │   Automation   │    │   Production    │
│                 │    │                 │    │                 │    │                 │
│ • VMs           │───▶│ • Docker        │───▶│ • Terraform    │───▶│ • Full Pipeline │
│ • Networking    │    │ • Kubernetes   │    │ • Ansible      │    │ • Monitoring    │
│ • Port Forward  │    │ • Orchestration│    │ • GitOps        │    │ • Load Balancing│
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
