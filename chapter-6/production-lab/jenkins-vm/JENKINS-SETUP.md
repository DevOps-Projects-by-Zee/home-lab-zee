# Step 4: Set Up Jenkins CI/CD (VM1)

## What is CI/CD?
**CI/CD** stands for **Continuous Integration/Continuous Deployment**:
- **CI**: Automatically test your code when you push changes
- **CD**: Automatically deploy your app when tests pass
- **Jenkins**: The tool that automates this entire process

**In simple terms**: Push code → Jenkins builds it → Tests run → App deploys automatically

---

## Step 4.1: SSH into Jenkins VM

```bash
vagrant ssh jenkins
```

**What this does**: Connects you to the Jenkins virtual machine where we'll set up everything.

**Expected output**: You'll see a command prompt like `vagrant@jenkins-server:~$`

---

## Step 4.2: Install and Configure Jenkins

### Create Jenkins Setup Directory

```bash
mkdir -p ~/jenkins-setup
cd ~/jenkins-setup
```

**What this does**: Creates a folder to store Jenkins configuration files.

### Create Jenkins Docker Compose File

```bash
cat > docker-compose.yml << 'EOF'
version: '3.3'

services:
  jenkins:
    image: jenkins/jenkins:lts
    container_name: jenkins-server
    user: root
    ports:
      - "8080:8080"      # Jenkins web interface
      - "50000:50000"    # Jenkins agent communication
    volumes:
      - jenkins_data:/var/jenkins_home  # Stores all Jenkins data
      - /var/run/docker.sock:/var/run/docker.sock  # Allows Jenkins to use Docker
      - /usr/bin/docker:/usr/bin/docker  # Docker binary for Jenkins
    environment:
      - JENKINS_OPTS=--httpPort=8080
    networks:
      - jenkins_network
    restart: unless-stopped

volumes:
  jenkins_data:

networks:
  jenkins_network:
    driver: bridge
EOF
```

**What this does**: 
- Creates a configuration file that tells Docker how to run Jenkins
- Maps port 8080 (Jenkins web UI) - **Note**: This will be accessible at `http://localhost:8086` on your Mac (due to port forwarding)
- Gives Jenkins access to Docker so it can build containers
- Creates a persistent volume to save Jenkins settings

**Key points**:
- `jenkins/jenkins:lts` = Long Term Support version (stable)
- `jenkins_data` = Where Jenkins saves all your pipelines and settings
- Port 8080 in VM → Port 8086 on your Mac (configured in Vagrantfile)

### Start Jenkins

```bash
docker-compose up -d
```

**What this does**: Downloads and starts Jenkins in the background.

**Expected output**:
```
Creating network "jenkins-setup_jenkins_network" with the default driver
Creating volume "jenkins-setup_jenkins_data" with default driver
Pulling jenkins (jenkins/jenkins:lts)...
Creating jenkins-server ... done
```

**Note**: First time will take 2-3 minutes to download the Jenkins image.

### Wait for Jenkins to Start

```bash
docker-compose logs -f jenkins
```

**What this does**: Shows Jenkins startup logs so you can see when it's ready.

**Look for this important message** (press `Ctrl+C` after you see it):
```
Jenkins initial setup is required. An admin user has been created and a password generated.
Please use the following password to proceed to installation:

a1b2c3d4e5f6g7h8i9j0

This may also be found at: /var/jenkins_home/secrets/initialAdminPassword
```

**⚠️ IMPORTANT**: Copy this password! You'll need it in the next step.

### Get the Password (if you missed it)

```bash
docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
```

**What this does**: Shows the admin password if you didn't copy it earlier.

---

## Step 4.3: Access Jenkins Web Interface

1. **Open your browser** on your Mac
2. **Go to**: `http://localhost:8086` (not 8080 - remember the port forwarding!)
3. **Enter the password** you copied earlier
4. **Click "Continue"**

**What you'll see**:
- Jenkins setup wizard
- Option to install recommended plugins (choose this)
- Wait 2-3 minutes for plugins to install
- Create admin user (or skip to use the generated password)
- Jenkins is ready!

---

## Step 4.4: Create Demo Application Repository

### Create Application Directory

```bash
mkdir -p ~/demo-app
cd ~/demo-app
git init
```

**What this does**: Creates a new Git repository for our demo app.

### Configure Git (Required First Time)

```bash
git config --global user.email "your-email@example.com"
git config --global user.name "Your Name"
```

**What this does**: Tells Git who you are (required for commits).

**Example**:
```bash
git config --global user.email "talk2osomudeya@gmail.com"
git config --global user.name "Osomudeya"
```

### Create Flask Application

```bash
cat > app.py << 'EOF'
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/') 
def home():
    return jsonify({
        'message': 'Hello from CI/CD!',
        'version': os.environ.get('APP_VERSION', '1.0.0'),
        'build': os.environ.get('BUILD_NUMBER', 'unknown')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF
```

**What this does**: Creates a simple Flask web app with two endpoints:
- `/` - Shows a welcome message with version info
- `/health` - Health check endpoint (used for testing)

### Create Dockerfile

```bash
cat > Dockerfile << 'EOF'
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
EOF
```

**What this does**: 
- Tells Docker how to build your app
- Uses Python 3.9
- Installs dependencies
- Runs the Flask app

### Create Requirements File

```bash
cat > requirements.txt << 'EOF'
Flask==2.3.3
EOF
```

**What this does**: Lists Python packages your app needs (just Flask for now).

### Create Jenkins Pipeline (Jenkinsfile)

```bash
cat > Jenkinsfile << 'EOF'
pipeline {
    agent any
    
    environment {
        APP_NAME = 'demo-app'
        APP_VERSION = '1.0.0'
        TARGET_HOST = '192.168.56.11'  // App server VM
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Code checked out automatically by Jenkins'
            }
        }
        
        stage('Build') {
            steps {
                script {
                    echo "Building ${APP_NAME} version ${APP_VERSION}-${BUILD_NUMBER}"
                    sh "docker build -t ${APP_NAME}:${BUILD_NUMBER} ."
                    sh "docker tag ${APP_NAME}:${BUILD_NUMBER} ${APP_NAME}:latest"
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    echo 'Running basic tests...'
                    sh """
                        docker run --rm --name test-${BUILD_NUMBER} \
                        -d -p 5001:5000 ${APP_NAME}:${BUILD_NUMBER}
                        
                        sleep 5
                        
                        # Test health endpoint
                        curl -f http://localhost:5001/health || exit 1
                        
                        # Stop test container
                        docker stop test-${BUILD_NUMBER}
                    """
                }
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying to app server...'
                    sh """
                        # Save image as tar file
                        docker save ${APP_NAME}:${BUILD_NUMBER} > demo-app-${BUILD_NUMBER}.tar
                        
                        # Copy to app server (this would normally be done via SSH)
                        echo 'In real scenario, would deploy to ${TARGET_HOST}'
                        
                        # Simulate deployment
                        docker run -d --name demo-app-${BUILD_NUMBER} \
                        -p 5002:5000 \
                        -e APP_VERSION=${APP_VERSION} \
                        -e BUILD_NUMBER=${BUILD_NUMBER} \
                        ${APP_NAME}:${BUILD_NUMBER}
                        
                        # Health check after deployment
                        sleep 10
                        curl -f http://localhost:5002/health || exit 1
                        
                        echo 'Deployment successful!'
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh """
                docker rm -f test-${BUILD_NUMBER} || true
                rm -f demo-app-${BUILD_NUMBER}.tar || true
            """
        }
        
        success {
            echo 'Pipeline completed successfully!'
        }
        
        failure {
            echo 'Pipeline failed! Check logs for details.'
        }
    }
}
EOF
```

**What this does**: Defines your CI/CD pipeline with 4 stages:

1. **Checkout**: Gets your code (automatic)
2. **Build**: Creates a Docker image of your app
3. **Test**: Runs your app in a test container and checks if it works
4. **Deploy**: Deploys the app (simulated in this demo)

**Pipeline flow**: Code → Build → Test → Deploy → Success/Failure

### Initialize Git Repository

```bash
git add .
git commit -m "Initial CI/CD demo application"
```

**What this does**: 
- `git add .` - Stages all files for commit
- `git commit` - Saves the files to Git with a message

**Expected output**:
```
[master (root-commit) 020446c] Initial CI/CD demo application
 4 files changed, 120 insertions(+)
 create mode 100644 Dockerfile
 create mode 100644 Jenkinsfile
 create mode 100644 app.py
 create mode 100644 requirements.txt
```

---

## Step 4.5: Push to GitHub (Optional but Recommended)

**Why push to GitHub?**: Jenkins can automatically trigger builds when you push code.

### Option A: Using SSH (Recommended)

```bash
# Generate SSH key (if you haven't already)
ssh-keygen -t ed25519 -C "your-email@example.com"
# Press Enter 3 times (accept defaults, no passphrase)

# Display your public key
cat ~/.ssh/id_ed25519.pub

# Copy the output and add it to GitHub:
# 1. Go to: https://github.com/settings/keys
# 2. Click "New SSH key"
# 3. Paste the key and save

# Add GitHub remote (replace YOUR-USERNAME and REPO-NAME)
git remote add origin git@github.com:YOUR-USERNAME/REPO-NAME.git

# Add GitHub to known hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null

# Push code
git branch -M main  # GitHub uses 'main' not 'master'
git push -u origin main
```

**What this does**: 
- Creates a secure connection to GitHub
- Uploads your code to GitHub
- Jenkins can now pull from GitHub automatically

### Option B: Using HTTPS

```bash
# Add remote
git remote add origin https://github.com/YOUR-USERNAME/REPO-NAME.git

# Push (you'll need a Personal Access Token as password)
git branch -M main
git push -u origin main
```

**Note**: GitHub requires a Personal Access Token (not password):
- Go to: https://github.com/settings/tokens
- Generate new token (classic)
- Select `repo` scope
- Use token as password when pushing

---

## Step 4.6: Verify Everything Works

### Check Jenkins is Running

```bash
docker ps | grep jenkins
```

**Expected**: You should see `jenkins-server` in the list.

### Check Jenkins Logs

```bash
docker-compose -f ~/jenkins-setup/docker-compose.yml logs --tail=20 jenkins
```

**Expected**: No errors, Jenkins should be running.

### Access Jenkins Web UI

1. Open browser: `http://localhost:8086`
2. You should see the Jenkins dashboard
3. If you see login, use the password from earlier

---

## Troubleshooting

### Jenkins won't start

```bash
# Check if port 8080 is already in use
docker ps | grep 8080

# Check Jenkins logs for errors
docker-compose logs jenkins

# Restart Jenkins
docker-compose restart jenkins
```

### Can't access Jenkins at localhost:8086

1. **Check port forwarding**: The Vagrantfile should forward VM port 8080 → Host port 8086
2. **Check if Jenkins is running**: `docker ps | grep jenkins`
3. **Check VM is running**: `vagrant status jenkins`
4. **Try**: `http://localhost:8086` (not 8080)

### Git push fails

**"remote origin already exists"**:
```bash
git remote remove origin
git remote add origin <YOUR-REPO-URL>
```

**"Authentication failed"**:
- For HTTPS: Use Personal Access Token, not password
- For SSH: Make sure you added the SSH key to GitHub

**"Host key verification failed"**:
```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

### Jenkins can't build Docker images

**Error**: "Cannot connect to Docker daemon"

**Solution**: Make sure Docker socket is mounted:
```bash
# Check docker-compose.yml has:
# - /var/run/docker.sock:/var/run/docker.sock
```

---

## What's Next?

After completing this step, you should have:
- ✅ Jenkins running at `http://localhost:8086`
- ✅ Demo app code in `~/demo-app`
- ✅ Git repository initialized
- ✅ Code pushed to GitHub (optional)

**Next Steps**: See Step 4.7 below for detailed instructions!

---

## Step 4.7: Configure Jenkins Pipeline Job

Now that Jenkins is running and your code is ready, let's create a Jenkins job that will automatically build, test, and deploy your app.

### Step 4.7.1: Access Jenkins Web Interface

1. **Open your browser** on your Mac
2. **Navigate to**: `http://localhost:8086`
3. **Login** with your admin credentials (password from Step 4.2)

**What you'll see**: Jenkins dashboard with options to create jobs.

---

### Step 4.7.2: Install Required Jenkins Plugins

**Why**: Jenkins needs plugins to work with Git and Docker.

1. **Click** "Manage Jenkins" (left sidebar)
2. **Click** "Manage Plugins"
3. **Go to** "Available" tab
4. **Search and install** these plugins (check the boxes):
   - ✅ **Git** (usually pre-installed)
   - ✅ **Docker Pipeline** (for Docker support)
   - ✅ **Pipeline** (for Jenkinsfile support)
   - ✅ **GitHub** (if using GitHub)
5. **Click** "Install without restart" or "Download now and install after restart"
6. **Wait** for installation (2-3 minutes)
7. **Restart Jenkins** if prompted

**What this does**: Adds features Jenkins needs to run your pipeline.

---

### Step 4.7.3: Configure Git in Jenkins (If Using GitHub)

**Option A: Using SSH (Recommended)**

1. **SSH into Jenkins VM**:
   ```bash
   vagrant ssh jenkins
   ```

2. **Copy your SSH key** (if you already generated one):
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   
   **If you don't have a key**, generate one:
   ```bash
   ssh-keygen -t ed25519 -C "your-email@example.com"
   # Press Enter 3 times
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Add the key to GitHub**:
   - Copy the output from step 2
   - Go to: https://github.com/settings/keys
   - Click "New SSH key"
   - Paste and save

4. **Add GitHub to known hosts**:
   ```bash
   ssh-keyscan github.com >> ~/.ssh/known_hosts
   ```

**Option B: Using HTTPS with Personal Access Token**

1. **Generate a GitHub Personal Access Token**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name: "Jenkins"
   - Select scopes: ✅ `repo` (full control)
   - Click "Generate token"
   - **Copy the token** (you won't see it again!)

2. **In Jenkins Web UI**:
   - Go to: "Manage Jenkins" → "Manage Credentials"
   - Click "System" → "Global credentials"
   - Click "Add Credentials"
   - Kind: "Username with password"
   - Username: Your GitHub username
   - Password: Your Personal Access Token
   - ID: `github-token` (or any name)
   - Click "OK"

---

### Step 4.7.4: Create a New Pipeline Job

1. **In Jenkins Web UI**, click **"New Item"** (or "Create a job")

2. **Enter job name**: `demo-app-pipeline` (or any name)

3. **Select**: "Pipeline" (not Freestyle project)

4. **Click** "OK"

**What this does**: Creates a new Jenkins job that will run your pipeline.

---

### Step 4.7.5: Configure the Pipeline

You'll see a configuration page. Fill in these sections:

#### General Settings

- ✅ **Description**: "CI/CD Pipeline for Demo App" (optional)

#### Pipeline Section

**Definition**: Select "Pipeline script from SCM"

**SCM**: Select "Git"

**Repository URL**: 
- **If using GitHub SSH**: `git@github.com:YOUR-USERNAME/demo-app.git`
- **If using GitHub HTTPS**: `https://github.com/YOUR-USERNAME/demo-app.git`
- **If using local repo**: Leave blank (we'll configure differently)

**Credentials**: 
- If using HTTPS: Select your GitHub token credential
- If using SSH: Leave blank (uses SSH keys from VM)

**Branches to build**: `*/main` or `*/master` (depending on your branch)

**Script Path**: `Jenkinsfile` (this is the name of your pipeline file)

**What this does**: Tells Jenkins to:
- Get code from your Git repository
- Look for a file called `Jenkinsfile`
- Run the pipeline defined in that file

#### Alternative: Pipeline Script (If Not Using Git)

If you haven't pushed to GitHub yet, you can paste the pipeline directly:

1. **Definition**: Select "Pipeline script"
2. **Paste your Jenkinsfile content** in the script box
3. **Note**: This won't pull from Git, but will run the pipeline

---

### Step 4.7.6: Save and Run Your First Build

1. **Click** "Save" at the bottom

2. **You'll see your job page**. Click **"Build Now"** (left sidebar)

3. **Watch the build**:
   - You'll see a build appear in "Build History"
   - Click on the build number (#1)
   - Click "Console Output" to see real-time logs

**What you'll see**:
```
Started by user admin
Running in Durability level: PERFORMANCE_OPTIMIZED
[Pipeline] Start of Pipeline
[Pipeline] node
[Pipeline] {
[Pipeline] stage
[Pipeline] { (Checkout)
[Pipeline] echo
Code checked out automatically by Jenkins
[Pipeline] }
[Pipeline] stage
[Pipeline] { (Build)
[Pipeline] script
[Pipeline] {
[Pipeline] echo
Building demo-app version 1.0.0-1
...
```

**Expected result**: 
- ✅ All stages should show green checkmarks
- ✅ Final message: "Pipeline completed successfully!"

---

### Step 4.7.7: Verify the Deployment

After the build completes successfully:

1. **Check if your app is running**:
   ```bash
   # SSH into Jenkins VM
   vagrant ssh jenkins
   
   # Check running containers
   docker ps | grep demo-app
   ```

2. **Test the deployed app**:
   ```bash
   # The app should be running on port 5002
   curl http://localhost:5002/
   curl http://localhost:5002/health
   ```

**Expected output**:
```json
{
  "message": "Hello from CI/CD!",
  "version": "1.0.0",
  "build": "1"
}
```

---

### Step 4.7.8: Set Up Automatic Builds (Optional)

**Trigger builds automatically when you push code to GitHub:**

1. **In your Jenkins job**, click **"Configure"**

2. **Scroll to** "Build Triggers" section

3. **Check**: ✅ "GitHub hook trigger for GITScm polling"

4. **Or check**: ✅ "Poll SCM" and enter: `H/5 * * * *` (checks every 5 minutes)

5. **Click** "Save"

**What this does**: 
- Jenkins will automatically check for code changes
- When you push to GitHub, Jenkins will start a new build
- No manual "Build Now" needed!

**For GitHub Webhooks** (more advanced):
- Go to your GitHub repo → Settings → Webhooks
- Add webhook: `http://YOUR-JENKINS-URL/github-webhook/`
- This triggers builds instantly when you push

---

## Step 4.7.9: Understanding Build Results

### Build Status Indicators

- 🟢 **Blue/Green**: Build succeeded
- 🔴 **Red**: Build failed
- 🟡 **Yellow**: Build unstable (tests passed but warnings)
- ⚪ **Gray**: Build in progress

### Viewing Build Details

1. **Click on any build number** in "Build History"
2. **View stages**: See which stages passed/failed
3. **Console Output**: See detailed logs of what happened
4. **Changes**: See what code changed in this build

### Common Issues

**Build fails at "Checkout" stage**:
- ❌ Problem: Can't connect to Git repository
- ✅ Solution: Check repository URL and credentials

**Build fails at "Build" stage**:
- ❌ Problem: Docker build error
- ✅ Solution: Check Dockerfile syntax, ensure Docker is running

**Build fails at "Test" stage**:
- ❌ Problem: Health check failed
- ✅ Solution: Check if app is starting correctly, check logs

**Build fails at "Deploy" stage**:
- ❌ Problem: Port conflict or container issue
- ✅ Solution: Stop old containers: `docker rm -f demo-app-*`

---

## Step 4.7.10: Making Changes and Seeing CI/CD in Action

**Now experience the power of CI/CD:**

1. **Make a change to your app**:
   ```bash
   # SSH into Jenkins VM
   vagrant ssh jenkins
   cd ~/demo-app
   
   # Edit the app
   nano app.py
   # Change the message to: "Hello from CI/CD - Updated!"
   ```

2. **Commit and push**:
   ```bash
   git add app.py
   git commit -m "Update welcome message"
   git push origin main
   ```

3. **Watch Jenkins**:
   - Go to Jenkins web UI: `http://localhost:8086`
   - You should see a new build start automatically (if you set up polling)
   - Or click "Build Now" manually

4. **See the magic**:
   - Jenkins detects the change
   - Builds a new Docker image
   - Tests it
   - Deploys it
   - All automatically!

**This is CI/CD in action!** 🎉

---

## Quick Reference

### Important URLs
- **Jenkins Web UI**: `http://localhost:8086`
- **Jenkins Admin Password**: Check with `docker exec jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword`

### Important Commands
```bash
# Start Jenkins
cd ~/jenkins-setup && docker-compose up -d

# Stop Jenkins
docker-compose down

# View Jenkins logs
docker-compose logs -f jenkins

# Restart Jenkins
docker-compose restart jenkins

# Check Jenkins status
docker ps | grep jenkins
```

### File Locations
- **Jenkins config**: `~/jenkins-setup/docker-compose.yml`
- **Demo app**: `~/demo-app/`
- **Jenkins data**: Stored in Docker volume `jenkins_data`

---

## Understanding the Pipeline

Your `Jenkinsfile` defines a **CI/CD pipeline**:

```
┌──────────┐    ┌────────┐    ┌────────┐    ┌──────────┐
│ Checkout │ -> │  Build  │ -> │  Test  │ -> │  Deploy  │
└──────────┘    └────────┘    └────────┘    └──────────┘
   (Get code)   (Docker image)  (Run tests)   (Deploy app)
```

**What happens**:
1. **Checkout**: Jenkins gets your code from Git
2. **Build**: Creates a Docker image with your app
3. **Test**: Runs the app and checks if it works
4. **Deploy**: Deploys the app (simulated in this demo)

**If any stage fails**: The pipeline stops and you get notified!

