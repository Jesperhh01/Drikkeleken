# Quick Start - AWS Elastic Beanstalk Deployment

## ⚡ Fast Deployment

### Option 1: Using the Deploy Script (Recommended)
```bash
./deploy.sh
```
Follow the interactive prompts to:
- Initialize EB
- Create environment
- Deploy application
- Manage environment variables
- View logs and status

### Option 2: Manual Commands

```bash
# 1. Initialize (first time only)
eb init

# 2. Create environment
eb create drikkeleken-prod --instance-type t3.micro --single

# 3. Deploy
eb deploy

# 4. Open in browser
eb open
```

## 📋 Prerequisites Checklist

- [ ] AWS Account created
- [ ] AWS CLI installed: `pip install awscli`
- [ ] EB CLI installed: `pip install awsebcli`
- [ ] AWS credentials configured: `aws configure`

## 🔧 Configuration

### Environment Variables (Optional)
```bash
eb setenv SECRET_KEY="your-production-secret-key-here"
eb setenv FLASK_ENV=production
```

### Instance Types
- **Development/Low Traffic**: `t3.micro` (Free tier eligible)
- **Medium Traffic**: `t3.small`
- **High Traffic**: `t3.medium` or enable auto-scaling

## 📁 Files for EB Deployment

All necessary files have been created:

✅ `application.py` - EB entry point  
✅ `.ebextensions/` - EB configuration  
✅ `.ebignore` - Files to exclude  
✅ `requirements-production.txt` - Production dependencies  
✅ `Procfile` - Process configuration  
✅ `runtime.txt` - Python version  
✅ `deploy.sh` - Deployment helper script  

## 🚀 Deployment Workflow

```bash
# Initial setup
./deploy.sh  # Select option 1: Initialize

# Create environment
./deploy.sh  # Select option 2: Create environment

# Deploy updates
./deploy.sh  # Select option 3: Deploy application

# Check status
./deploy.sh  # Select option 4: Check status

# View logs
./deploy.sh  # Select option 5: View logs
```

## 🏥 Health Check

Your app includes a health endpoint at `/health` for EB monitoring.

Test it: `curl https://your-app.elasticbeanstalk.com/health`

## 💰 Cost Estimates

- **t3.micro (single instance)**: ~$7-10/month
- **t3.small**: ~$15-20/month
- Includes compute, storage, and data transfer

**Free Tier**: New AWS accounts get 750 hours/month of t3.micro for 12 months.

## 🔍 Troubleshooting

```bash
# View application logs
eb logs

# Check environment health
eb health

# SSH into instance
eb ssh

# Check detailed logs on instance
eb ssh
tail -f /var/log/eb-engine.log
tail -f /var/app/current/application.log
```

## 🛑 Cleanup

To avoid charges when done:
```bash
eb terminate drikkeleken-prod
```

## 📚 Full Documentation

See [EB_DEPLOYMENT.md](./EB_DEPLOYMENT.md) for detailed documentation.

---

**Need Help?** Check AWS EB documentation: https://docs.aws.amazon.com/elasticbeanstalk/

