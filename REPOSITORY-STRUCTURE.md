# Repository Structure

Complete guide to the repository organization and file structure.

## 📁 Directory Structure

```
devops-pipeline/
│
├── README.md                    # Main entry point
├── PORT-REFERENCE.md            # Port reference guide
├── TROUBLESHOOTING-INDEX.md     # Troubleshooting guide
├── SIMPLIFIED-ARCHITECTURE.md   # Architecture overview
├── REPOSITORY-STRUCTURE.md      # This file
│
├── docs/                        # Reference documentation
│   ├── PREREQUISITES.md         # Installation requirements
│   ├── COMMAND-REFERENCE.md     # Command quick reference
│   ├── NETWORK-ARCHITECTURE.md  # Network diagrams and IPs
│   ├── QUICK-START.md           # Quick start guide
│   └── DECISION-TREES.md        # Learning path selection
│
├── assets/                       # Images and diagrams
│   ├── architecture-simple.jpg
│   └── architecture-simple2.jpg
│
├── chapter-1/                   # Virtualization Platform
│   ├── README.md
│   ├── Vagrantfile
│   ├── install-virtualbox.sh
│   ├── install-vagrant.sh
│   ├── proxmox-setup.sh
│   └── start-webserver.sh
│
├── chapter-2/                   # Containers (Docker + Minikube)
│   ├── README.md
│   ├── Dockerfile
│   ├── docker-compose.yml
│   ├── nginx-deployment.yaml
│   ├── index.html
│   ├── install-docker.sh
│   └── install-k8s-tools.sh
│
├── chapter-2b/                  # MicroK8s (Linux Native)
│   ├── README.md
│   └── nginx-deployment.yaml
│
├── chapter-3/                   # Infrastructure as Code
│   ├── README.md
│   ├── main.tf                  # Terraform configuration
│   ├── inventory.ini            # Ansible inventory
│   ├── webserver.yml            # Ansible playbook
│   ├── install-terraform.sh
│   └── install-ansible.sh
│
├── chapter-4/                   # Portfolio Projects
│   ├── README.md
│   ├── project1/                # Load-Balanced Web App
│   │   ├── docker-compose.yml
│   │   ├── nginx.conf
│   │   └── html/
│   │       └── index.html
│   └── project2/                # Monitoring Stack
│       ├── docker-compose.yml
│       └── prometheus.yml
│
├── chapter-5/                   # Real-World Integration
│   ├── README.md
│   ├── Vagrantfile
│   ├── docker-compose.yml
│   ├── prometheus.yml
│   ├── TROUBLESHOOTING.md
│   ├── terraform/               # Terraform project
│   │   ├── main.tf
│   │   └── terraform.tfstate*
│   ├── ansible/                 # Ansible project
│   │   └── site.yml
│   ├── docker-app/              # Docker application
│   │   ├── docker-compose.yml
│   │   └── index.html
│   ├── k3d-lab/                 # Kubernetes lab
│   │   ├── Vagrantfile
│   │   └── setup-k3d.sh
│   ├── gitops-demo/             # GitOps workflow
│   │   ├── Vagrantfile
│   │   ├── deploy.sh
│   │   └── app/
│   │       ├── docker-compose.yml
│   │       └── site/
│   │           └── index.html
│   └── monitoring-lab/          # Monitoring lab
│       ├── Vagrantfile
│       ├── docker-compose.yml
│       └── prometheus.yml
│
└── chapter-6/                   # Production Environment
    ├── README.md
    └── production-lab/
        ├── Vagrantfile          # 3-VM setup
        ├── jenkins-vm/          # CI/CD Server
        │   ├── docker-compose.yml
        │   ├── JENKINS-SETUP.md
        │   └── Push-to-github-steps.md
        ├── app-vm/              # Application + Monitoring
        │   ├── app.py
        │   ├── Dockerfile
        │   ├── requirements.txt
        │   ├── docker-compose.yml
        │   ├── prometheus.yml
        │   ├── alert_rules.yml
        │   ├── TROUBLESHOOTING.md
        │   ├── grafana-dashboards/
        │   │   ├── dashboard.yml
        │   │   └── flask-app-dashboard.json
        │   ├── grafana-datasources/
        │   │   └── prometheus.yml
        │   └── debugging/       # Networking debugging examples
        │       ├── docker-compose-broken.yml
        │       ├── docker-compose-fixed.yml
        │       └── prometheus-fixed.yml
        └── database-vm/         # Database + Proxy
            ├── docker-compose.yml
            ├── init-db.sql
            └── nginx.conf
```

---

## 📄 File Types & Purposes

### Configuration Files

| File Type | Purpose | Examples |
|-----------|---------|----------|
| `Vagrantfile` | VM definitions | `chapter-1/Vagrantfile` |
| `docker-compose.yml` | Multi-container apps | `chapter-2/docker-compose.yml` |
| `Dockerfile` | Container images | `chapter-2/Dockerfile` |
| `*.tf` | Terraform configs | `chapter-3/main.tf` |
| `*.yml` | Ansible playbooks | `chapter-3/webserver.yml` |
| `*.yaml` | Kubernetes configs | `chapter-2/nginx-deployment.yaml` |
| `*.ini` | Ansible inventory | `chapter-3/inventory.ini` |
| `*.conf` | Service configs | `chapter-4/project1/nginx.conf` |

### Documentation Files

| File | Purpose |
|------|---------|
| `README.md` | Main entry point, navigation |
| `PORT-REFERENCE.md` | All ports used in lab |
| `TROUBLESHOOTING-INDEX.md` | Common issues and solutions |
| `chapter-*/README.md` | Chapter-specific guides |
| `docs/*.md` | Reference documentation |

### Scripts

| Script | Purpose |
|--------|---------|
| `install-*.sh` | Installation scripts |
| `setup-*.sh` | Setup scripts |
| `start-*.sh` | Quick start scripts |
| `deploy.sh` | Deployment scripts |

---

## 🗂️ Chapter Organization

### Chapter 1: Virtualization
**Purpose:** Learn VM management  
**Files:** Vagrantfile, installation scripts  
**Output:** Running Ubuntu VM with web server

### Chapter 2: Containers
**Purpose:** Learn Docker and Kubernetes basics  
**Files:** Dockerfile, docker-compose.yml, K8s manifests  
**Output:** Containerized applications

### Chapter 2B: MicroK8s
**Purpose:** Native Kubernetes on Linux  
**Files:** K8s manifests  
**Output:** Production-grade K8s cluster

### Chapter 3: Infrastructure as Code
**Purpose:** Learn Terraform and Ansible  
**Files:** Terraform configs, Ansible playbooks  
**Output:** Automated infrastructure

### Chapter 4: Portfolio Projects
**Purpose:** Build real projects  
**Files:** Complete project setups  
**Output:** Load-balanced app, monitoring stack

### Chapter 5: Real-World Integration
**Purpose:** Combine all tools  
**Files:** Multiple project directories  
**Output:** Integrated DevOps pipeline

### Chapter 6: Production Environment
**Purpose:** Production debugging and operations  
**Files:** Complete 3-VM setup with all services  
**Output:** Production-like environment

---

## 📋 File Naming Conventions

### Standard Names

- `README.md` - Chapter/project documentation
- `Vagrantfile` - VM configuration (always this name)
- `docker-compose.yml` - Docker Compose config
- `Dockerfile` - Container image definition
- `requirements.txt` - Python dependencies
- `inventory.ini` - Ansible inventory
- `main.tf` - Main Terraform configuration

### Descriptive Names

- `install-*.sh` - Installation scripts
- `setup-*.sh` - Setup scripts
- `*-deployment.yaml` - Kubernetes deployments
- `prometheus.yml` - Prometheus configuration
- `nginx.conf` - Nginx configuration

### Special Files

- `docker-compose-broken.yml` - Intentionally broken (for learning)
- `docker-compose-fixed.yml` - Fixed version
- `TROUBLESHOOTING.md` - Troubleshooting guides
- `*.tfstate*` - Terraform state (gitignored)

---

## 🔍 Finding Files

### By Purpose

**Want to start a VM?**
- Look for `Vagrantfile` in chapter directories

**Want Docker setup?**
- Look for `docker-compose.yml` or `Dockerfile`

**Want Kubernetes?**
- Look for `*-deployment.yaml` files

**Want installation help?**
- Look for `install-*.sh` scripts

**Want troubleshooting?**
- Look for `TROUBLESHOOTING.md` files

### By Tool

**Vagrant:**
- `Vagrantfile` files

**Docker:**
- `Dockerfile`, `docker-compose.yml`

**Kubernetes:**
- `*-deployment.yaml`, `*-service.yaml`

**Terraform:**
- `*.tf` files

**Ansible:**
- `*.yml` playbooks, `inventory.ini`

---

## 📚 Documentation Hierarchy

```
README.md (Main)
    ├── Quick navigation
    ├── Chapter links
    └── Reference links
        │
        ├── docs/
        │   ├── PREREQUISITES.md
        │   ├── COMMAND-REFERENCE.md
        │   ├── NETWORK-ARCHITECTURE.md
        │   ├── QUICK-START.md
        │   └── DECISION-TREES.md
        │
        ├── PORT-REFERENCE.md
        ├── TROUBLESHOOTING-INDEX.md
        │
        └── chapter-*/
            └── README.md
```

---

## 🎯 Quick File Lookup

### Common Tasks

**"I want to install VirtualBox"**
→ `chapter-1/install-virtualbox.sh`

**"I want to start a VM"**
→ `chapter-1/Vagrantfile`

**"I want Docker commands"**
→ `docs/COMMAND-REFERENCE.md`

**"I want to check ports"**
→ `PORT-REFERENCE.md`

**"I want to troubleshoot"**
→ `TROUBLESHOOTING-INDEX.md`

**"I want Kubernetes"**
→ `chapter-2/` (Minikube) or `chapter-2b/` (MicroK8s)

**"I want production setup"**
→ `chapter-6/production-lab/`

---

## 📝 File Maintenance

### Files You Can Modify

- ✅ Configuration files (Vagrantfile, docker-compose.yml, etc.)
- ✅ Scripts (customize for your needs)
- ✅ Documentation (add notes)

### Files You Shouldn't Modify

- ❌ State files (`*.tfstate`, `*.tfstate.backup`)
- ❌ Generated files (unless regenerating)

### Files to Gitignore

- `*.tfstate`
- `*.tfstate.backup`
- `.vagrant/`
- `*.log`
- `.DS_Store`

---

## 🔗 Cross-References

Files reference each other:

- Chapter READMEs link to main README
- Main README links to all references
- Troubleshooting links to relevant chapters
- Port reference links to chapters

**Always check the main README first for navigation.**

---

## 📊 Repository Statistics

- **Total Chapters:** 6 (plus 2B)
- **Total Projects:** 8+
- **Configuration Files:** 50+
- **Documentation Files:** 15+
- **Scripts:** 10+

---

## 🆘 Need Help Finding Something?

1. Check [README.md](README.md) for navigation
2. Use search in your editor/IDE
3. Check [TROUBLESHOOTING-INDEX.md](TROUBLESHOOTING-INDEX.md)
4. Look in chapter-specific READMEs

---

**📖 Related:**
- [Main README](README.md)
- [Quick Start](docs/QUICK-START.md)
- [Decision Trees](docs/DECISION-TREES.md)

