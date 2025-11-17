
## Steps to push your code to GitHub

### Step 1: Create a GitHub repository
1. Go to https://github.com/new
2. Repository name: `demo-app` (or your choice)
3. Visibility: Public or Private
4. Do not check "Initialize this repository with a README"
5. Click "Create repository"

### Step 2: Add remote and push

**Option A: Using HTTPS (requires Personal Access Token)**

```bash
# SSH into Jenkins VM
vagrant ssh jenkins

# Navigate to your app
cd ~/demo-app

# Add remote (replace YOUR-USERNAME and REPO-NAME)
git remote add origin https://github.com/YOUR-USERNAME/REPO-NAME.git

# Verify remote
git remote -v

# Push code (you'll be prompted for username and password/token)
git push -u origin master
```

**Note:** GitHub no longer accepts passwords. Use a Personal Access Token:
- Go to: https://github.com/settings/tokens
- Generate new token (classic)
- Select `repo` scope
- Use the token as the password when pushing

**Option B: Using SSH (recommended for automation)**

```bash
# Inside Jenkins VM, generate SSH key (if not exists)
ssh-keygen -t ed25519 -C "talk2osomudeya@gmail.com"
# Press Enter to accept default location
# Press Enter twice for no passphrase (or set one)

# Display public key
cat ~/.ssh/id_ed25519.pub

# Copy the output and add it to GitHub:
# Go to: https://github.com/settings/keys
# Click "New SSH key"
# Paste the key and save

# Add remote using SSH
git remote add origin git@github.com:YOUR-USERNAME/REPO-NAME.git

# Push
git push -u origin master
```

### Quick command reference

If you already have a repository URL, run these inside the Jenkins VM:

```bash
cd ~/demo-app
git remote add origin <YOUR-REPO-URL>
git remote -v                    # Verify
git push -u origin master       # Push
```

### Troubleshooting

**If you get "remote origin already exists":**
```bash
git remote remove origin
git remote add origin <YOUR-REPO-URL>
```

**If you need to change the branch name (GitHub uses `main` by default):**
```bash
git branch -M main
git push -u origin main
```

Share your GitHub username or repository URL if you want me to generate the exact commands.