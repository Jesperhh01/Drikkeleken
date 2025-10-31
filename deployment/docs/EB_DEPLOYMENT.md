# AWS Elastic Beanstalk Deployment Guide

## Prerequisites
1. Install AWS CLI and EB CLI:
   ```bash
   pip install awsebcli
   ```

2. Configure AWS credentials:
   ```bash
   aws configure
   ```

## Deployment Steps

### 1. Initialize Elastic Beanstalk
```bash
eb init
```

**Follow these prompts:**
1. **Select a default region**: Choose your preferred region (e.g., `us-east-1`)
2. **Application name**: Enter `drikkeleken` (or press Enter for default)
3. **Platform**: Select `Python`
4. **Platform branch**: Select `Python 3.9` (option 4) - matches your current Python
5. **CodeCommit**: Enter `n` (No) - **IMPORTANT: Answer 'n' to avoid CodeCommit errors**
6. **SSH**: Choose `y` if you want SSH access (recommended for debugging)

### 2. Create an Environment
```bash
eb create drikkeleken-prod --instance-type t3.micro --single
```

**IMPORTANT**: The environment creation takes 5-10 minutes. You'll see:
- Status: "Launching" → "Pending" → "Ready"
- Health: "Grey" → "Green"

**Wait for the environment to be ready before deploying!**

To monitor the creation progress:
```bash
# Watch status (Ctrl+C to exit)
watch -n 10 eb status

# Or check health interactively
eb health
```

The environment is ready when:
- ✅ Status shows: "Ready"
- ✅ Health shows: "Green" or "Ok"

### 3. Wait for Environment to Finish Creating

After running `eb create`, **DO NOT run `eb deploy` immediately**. 

Check if environment is ready:
```bash
eb status
```

Look for:
```
Status: Ready    ← Must say "Ready", not "Launching" or "Pending"
Health: Green    ← Should be Green
```

If it still shows "Launching" or "Pending", wait a few minutes and check again.

### 4. Set Environment Variables (if needed)
```bash
eb setenv SECRET_KEY="your-secret-key-here"
eb setenv FLASK_ENV=production
```

### 5. Deploy Your Application

**Only run this after environment status is "Ready"!**

```bash
eb deploy
```

If you get an error like:
```
ERROR: InvalidParameterValueError - Environment is in an invalid state
```

This means the environment isn't ready yet. Wait and try again.

### 6. Open Your Application
```bash
eb open
```

## Useful Commands

### Check Status
```bash
eb status
```

### View Logs
```bash
eb logs
```

### SSH into Instance
```bash
eb ssh
```

### Terminate Environment (when done)
```bash
eb terminate drikkeleken-prod
```

## Files Created for EB

- `application.py` - Main entry point (EB looks for 'application' variable)
- `.ebextensions/python.config` - Python/WSGI configuration
- `.ebextensions/01_packages.config` - System packages and container commands
- `.ebignore` - Files to exclude from deployment
- `requirements-production.txt` - Minimal production dependencies
- `wait-for-ready.sh` - Helper script to check if environment is ready

**Note**: `Procfile` is NOT used. Python 3.9 on Amazon Linux 2023 uses the WSGI configuration from `.ebextensions/python.config` instead.

## Important Notes

1. **Application Name**: EB looks for `application.py` with an `application` variable
2. **Static Files**: Configured to serve from `/static` → `app/static`
3. **Environment**: Set to production by default
4. **WSGI Path**: Points to `application:application`

## Switching Requirements

If you need the full requirements.txt for development features:
```bash
# Backup current requirements
mv requirements.txt requirements-full.txt

# Use production requirements
cp requirements-production.txt requirements.txt

# Deploy
eb deploy

# Switch back for local development
mv requirements-full.txt requirements.txt
```

## Environment Variables

Set these in the EB console or via CLI:
- `SECRET_KEY` - Your secret key for sessions
- `FLASK_ENV` - Set to 'production'

## Troubleshooting

### Environment Not Ready Error
If you see: `ERROR: InvalidParameterValueError - Environment is in an invalid state`

**Solution**: The environment is still being created. You tried to deploy too soon.

1. Check status:
   ```bash
   eb status
   ```

2. Wait until you see:
   ```
   Status: Ready
   Health: Green
   ```

3. Monitor progress:
   ```bash
   # Option 1: Check status every 30 seconds
   watch -n 30 eb status
   
   # Option 2: Interactive health check
   eb health
   ```

4. Once ready (usually 5-10 minutes), then deploy:
   ```bash
   eb deploy
   ```

### CodeCommit Error During Init
If you see: `ERROR: ServiceError - CreateRepository request is not allowed`

**Solution**: This happens if you answered 'y' to CodeCommit. Simply answer 'n' when asked:
```
Do you wish to continue with CodeCommit? (Y/n): n
```

You don't need CodeCommit - EB will use your local Git repository for version tracking.

### Deployment Failures
If deployment fails:
1. Check logs: `eb logs`
2. Check health: `eb health`
3. SSH and check: `eb ssh` then `tail -f /var/log/eb-engine.log`

### Health Check Issues
If health checks fail, verify the `/health` endpoint:
```bash
curl https://your-app.elasticbeanstalk.com/health
```

Should return: `{"status":"healthy","service":"drikkeleken","version":"1.0"}`

## Cost Optimization

- Use `t3.micro` or `t3.small` for small traffic
- Consider `--single` flag for single instance (no load balancer)
- Set up Auto Scaling based on your needs

