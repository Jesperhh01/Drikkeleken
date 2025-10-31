# How to Update Your AWS Deployment

## ✅ Quick Method (What We Just Did)

Simply run this command from your project root:

```bash
eb deploy
```

That's it! The deployment takes about 1-2 minutes.

---

## 📋 Step-by-Step Guide

### Method 1: Direct Command (Fastest)

```bash
# From project root
eb deploy
```

### Method 2: Using the Deploy Script

```bash
cd deployment/aws-eb
./deploy.sh
# Choose option 3: Deploy application
```

---

## 🔍 What Happens During Deployment

1. EB packages your code into a zip file
2. Uploads it to AWS S3
3. Deploys to your EC2 instance
4. Restarts the application
5. Health checks confirm it's working

**Time**: ~1-2 minutes

---

## ✅ Verify Your Deployment

### Check Status
```bash
eb status
```

Look for:
- Status: **Ready** ✅
- Health: **Green** ✅

### Check Deployed Version
```bash
eb status | grep "Deployed Version"
```

### View Logs (if something goes wrong)
```bash
eb logs
```

### Test Your App
```bash
# Open in browser
eb open

# Or visit directly
curl http://drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com
```

---

## 📝 What Gets Deployed

EB automatically includes:
- ✅ All your Python code (`app/`, `main.py`, etc.)
- ✅ `application.py` (entry point)
- ✅ `requirements.txt` (dependencies)
- ✅ `.ebextensions/` (configuration)
- ✅ Static files (`app/static/`)
- ✅ Templates (`app/templates/`)

EB ignores (from `.ebignore`):
- ❌ `.venv/` (virtual environment)
- ❌ `__pycache__/`
- ❌ `.git/`
- ❌ `.env` files
- ❌ `deployment/` folder

---

## 🎯 Common Workflows

### After Making Code Changes

1. **Test locally first:**
   ```bash
   python main.py
   # Visit http://localhost:5001
   ```

2. **Deploy to AWS:**
   ```bash
   eb deploy
   ```

3. **Test on AWS:**
   ```bash
   eb open
   ```

### If Deployment Fails

1. **Check logs:**
   ```bash
   eb logs
   ```

2. **Check environment health:**
   ```bash
   eb health
   ```

3. **SSH into instance (if needed):**
   ```bash
   eb ssh
   ```

---

## 🚀 Your Latest Deployment

**What was deployed:**
- ✅ iPhone call modal with random names
- ✅ 20-challenge guarantee for phone popup
- ✅ Troll images with 10-click guarantee
- ✅ Updated styling and layouts
- ✅ All latest features

**Version**: `app-d2d8-251030_234646833380`  
**Time**: October 30, 2025 at 22:47 UTC  
**Status**: ✅ Successful  

**Your live app:**
- http://drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com
- http://halloweenfylla.no (if DNS is configured)

---

## 💡 Pro Tips

### Before Each Deployment

```bash
# Optional: Check if environment is ready
cd deployment/aws-eb
./wait-for-ready.sh
```

### After Each Deployment

```bash
# Verify health
eb health

# Check it works
eb open
```

### Keep Track of Versions

EB automatically creates version names. You can see them with:
```bash
eb appversion
```

---

## 🆘 Troubleshooting

### Deployment stuck or fails
```bash
eb abort  # Cancel current deployment
eb logs   # Check what went wrong
```

### App not responding after deployment
```bash
eb logs | grep -i error
```

### Want to rollback
```bash
eb deploy --version <previous-version-name>
```

---

## 📊 Monitoring Your App

```bash
# Real-time health
eb health

# Application logs
eb logs

# Environment events
eb events

# Environment info
eb status
```

---

## 🎓 Remember

- ✅ Always test locally first
- ✅ `eb deploy` updates AWS automatically
- ✅ Deployment takes 1-2 minutes
- ✅ Check `eb health` after deploying
- ✅ Your changes are live immediately after deployment completes

---

**Quick command to remember:**
```bash
eb deploy
```

That's all you need! 🎃

