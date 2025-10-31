# AWS Deployment Resources

This folder contains all AWS Elastic Beanstalk deployment resources organized for easy access.

## 📁 Folder Structure

```
deployment/
├── aws-eb/              # AWS EB scripts and configuration
│   ├── deploy.sh                    # Main deployment script
│   ├── check-deployment.sh          # Pre-deployment verification
│   ├── wait-for-ready.sh            # Check if environment is ready
│   ├── setup-custom-domain.sh       # Custom domain setup helper
│   ├── requirements-production.txt  # Production dependencies
│   ├── runtime.txt                  # Python version specification
│   └── Procfile.backup              # Backup (not used on AL2023)
│
└── docs/                # Documentation
    ├── AWS_QUICKSTART.md            # Quick deployment guide
    ├── EB_DEPLOYMENT.md             # Detailed EB deployment
    ├── EB_SETUP_SUMMARY.md          # Configuration reference
    ├── DEPLOY_QUICKREF.txt          # Command quick reference
    ├── SIMPLE_DOMAIN_SETUP.md       # Domain setup (no CLI needed)
    ├── CUSTOM_DOMAIN_SETUP.md       # Full domain guide
    ├── DOMAIN_QUICKREF.txt          # Domain quick reference
    └── SETUP_HALLOWEENFYLLA_NO.md   # Domain-specific setup
```

## 🚀 Quick Start

### First Time Deployment

1. **Run the deployment script:**
   ```bash
   cd deployment/aws-eb
   ./deploy.sh
   ```

2. **Follow the interactive prompts:**
   - Option 1: Initialize EB (first time)
   - Option 2: Create environment
   - Option 3: Deploy application

### Updating Your App

```bash
cd deployment/aws-eb
./deploy.sh
# Choose option 3: Deploy application
```

### Custom Domain Setup

```bash
cd deployment/aws-eb
./setup-custom-domain.sh
# Choose option 1 for Route 53 or option 3 for external DNS
```

## 📚 Documentation

### Deployment Guides
- **[AWS_QUICKSTART.md](docs/AWS_QUICKSTART.md)** - Fast deployment (start here!)
- **[EB_DEPLOYMENT.md](docs/EB_DEPLOYMENT.md)** - Detailed step-by-step
- **[EB_SETUP_SUMMARY.md](docs/EB_SETUP_SUMMARY.md)** - Configuration overview
- **[DEPLOY_QUICKREF.txt](docs/DEPLOY_QUICKREF.txt)** - Command reference card

### Domain Setup Guides
- **[SIMPLE_DOMAIN_SETUP.md](docs/SIMPLE_DOMAIN_SETUP.md)** - No AWS CLI needed!
- **[CUSTOM_DOMAIN_SETUP.md](docs/CUSTOM_DOMAIN_SETUP.md)** - Complete domain guide
- **[DOMAIN_QUICKREF.txt](docs/DOMAIN_QUICKREF.txt)** - Quick reference
- **[SETUP_HALLOWEENFYLLA_NO.md](docs/SETUP_HALLOWEENFYLLA_NO.md)** - Your domain setup

## 🛠️ Available Scripts

All scripts are in `deployment/aws-eb/`:

| Script | Purpose |
|--------|---------|
| `deploy.sh` | Main deployment tool (interactive menu) |
| `check-deployment.sh` | Verify all files are ready before deploying |
| `wait-for-ready.sh` | Check if EB environment is ready |
| `setup-custom-domain.sh` | Configure custom domain (Route 53 or external DNS) |

## 📋 Common Commands

```bash
# Check if ready to deploy
cd deployment/aws-eb
./check-deployment.sh

# Deploy or manage environment
./deploy.sh

# Check environment status
eb status

# View logs
eb logs

# Open app in browser
eb open

# Setup custom domain
./setup-custom-domain.sh
```

## 💡 Pro Tips

1. **Always check readiness first:**
   ```bash
   ./check-deployment.sh
   ```

2. **Wait for environment to be ready:**
   ```bash
   ./wait-for-ready.sh
   ```

3. **Use the interactive deploy script** - it handles requirements switching automatically

4. **For custom domains** - Use Cloudflare for free SSL (see SIMPLE_DOMAIN_SETUP.md)

## 🔗 Important Links

- **Route 53 Console**: https://console.aws.amazon.com/route53/
- **EB Console**: https://console.aws.amazon.com/elasticbeanstalk/
- **ACM Console** (SSL): https://console.aws.amazon.com/acm/
- **Your App**: http://drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com

## 📞 Need Help?

1. Check the docs in `deployment/docs/`
2. Run `./deploy.sh` for interactive help
3. See main [README.md](../README.md) for project overview

---

**All deployment resources organized and ready to use!** 🎃

