# Custom Domain Setup for Drikkeleken

## Overview

Your current AWS URL: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

You'll need:
1. A domain name (purchase from domain registrar if you don't have one)
2. Access to DNS settings (Route 53, Cloudflare, GoDaddy, etc.)
3. Optional: SSL certificate for HTTPS

---

## Option 1: Using AWS Route 53 (Recommended)

### Step 1: Register or Transfer Domain
If you don't have a domain yet:
```bash
# Go to AWS Route 53 Console
# Domains → Register Domain
# Search for available domain (e.g., drikkeleken.com)
# Purchase (~$12/year for .com)
```

### Step 2: Create Hosted Zone (if not auto-created)
```bash
# Route 53 → Hosted Zones → Create Hosted Zone
# Domain name: yourdomain.com
# Type: Public Hosted Zone
```

### Step 3: Get Your EB Environment CNAME
```bash
eb status | grep CNAME
```
Output: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

### Step 4: Create DNS Record in Route 53

**Via AWS Console:**
1. Go to Route 53 → Hosted Zones
2. Click on your domain
3. Click "Create Record"
4. Configure:
   - **Record name**: `www` (for www.yourdomain.com) or leave blank (for yourdomain.com)
   - **Record type**: `CNAME` (for www) or `A - Alias` (for root domain)
   - **Value/Route traffic to**: 
     - For CNAME (www): `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
     - For A Alias (root): Select "Alias to Elastic Beanstalk environment" → Choose your environment
5. Click "Create records"

**Via AWS CLI:**
```bash
# For www subdomain (CNAME)
aws route53 change-resource-record-sets --hosted-zone-id YOUR_ZONE_ID --change-batch '{
  "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
      "Name": "www.yourdomain.com",
      "Type": "CNAME",
      "TTL": 300,
      "ResourceRecords": [{"Value": "drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com"}]
    }
  }]
}'

# For root domain (A Alias)
aws route53 change-resource-record-sets --hosted-zone-id YOUR_ZONE_ID --change-batch '{
  "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
      "Name": "yourdomain.com",
      "Type": "A",
      "AliasTarget": {
        "HostedZoneId": "Z23TAZ6LKFMNIO",
        "DNSName": "drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com",
        "EvaluateTargetHealth": false
      }
    }
  }]
}'
```

---

## Option 2: Using External DNS Provider (Cloudflare, GoDaddy, Namecheap, etc.)

### Step 1: Login to Your DNS Provider

### Step 2: Add DNS Records

**For www.yourdomain.com:**
- **Type**: CNAME
- **Name**: www
- **Value**: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
- **TTL**: 300 (or Auto)

**For root domain (yourdomain.com):**

Most DNS providers don't support CNAME on root domain. Options:
1. **Use CNAME Flattening** (if available - Cloudflare has this)
2. **Use A record with IP** (not recommended - EB IPs can change)
3. **Redirect root to www** (common solution)

**Example for Cloudflare:**
1. DNS → Add Record
2. Type: CNAME
3. Name: @ (for root) or www
4. Target: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
5. Proxy status: Proxied (for SSL/CDN) or DNS only
6. Save

---

## Option 3: Quick Setup Script for Route 53

I'll create a script to automate this for you:

```bash
./setup-custom-domain.sh
```

This will:
1. Check if you have a hosted zone
2. Create DNS records pointing to your EB environment
3. Verify DNS propagation
4. Setup SSL (optional)

---

## Adding SSL Certificate (HTTPS)

### Option A: Using AWS Certificate Manager (ACM) - FREE

1. **Request Certificate:**
   ```bash
   # Via AWS Console
   # ACM → Request Certificate → Request a public certificate
   # Domain: yourdomain.com and www.yourdomain.com
   # Validation: DNS validation (easier with Route 53)
   ```

2. **Validate Certificate:**
   - ACM will provide CNAME records
   - Add them to Route 53 (or auto-validate if using Route 53)
   - Wait for validation (5-30 minutes)

3. **Attach to Load Balancer:**
   - EB Console → Configuration → Load Balancer
   - Add Listener: Port 443, Protocol HTTPS
   - Select your ACM certificate
   - Save and apply

### Option B: Using Cloudflare SSL - FREE
- Turn on "Proxy" for DNS record in Cloudflare
- Cloudflare provides automatic SSL
- No additional configuration needed!

---

## DNS Propagation

After adding DNS records:
- **Propagation time**: 5 minutes to 48 hours (usually < 1 hour)
- **Check propagation**: https://dnschecker.org

Test your domain:
```bash
# Check DNS resolution
nslookup www.yourdomain.com

# Check if site is accessible
curl -I http://www.yourdomain.com
```

---

## Common Domain Registrars & DNS Setup

### GoDaddy
1. My Products → Domain → DNS
2. Add Record → CNAME → www → `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

### Namecheap
1. Domain List → Manage → Advanced DNS
2. Add New Record → CNAME → www → `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

### Google Domains
1. DNS → Custom Records
2. CNAME → www → `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

### Cloudflare
1. DNS → Add Record
2. CNAME → www → `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
3. Proxy: Enabled (for free SSL)

---

## Testing Your Custom Domain

Once DNS propagates:

```bash
# Test HTTP
curl -I http://yourdomain.com

# Test HTTPS (if SSL configured)
curl -I https://yourdomain.com

# Check health endpoint
curl http://yourdomain.com/health
```

---

## Cost Breakdown

- **Domain Registration**: $12-15/year (.com)
- **Route 53 Hosted Zone**: $0.50/month
- **DNS Queries**: $0.40 per million queries (very cheap)
- **ACM SSL Certificate**: FREE
- **Cloudflare (alternative)**: FREE

**Total**: ~$12-20/year if using Route 53, or just domain cost if using Cloudflare

---

## Quick Setup Checklist

- [ ] Purchase/have domain name
- [ ] Get EB CNAME: `eb status | grep CNAME`
- [ ] Login to DNS provider (Route 53 recommended)
- [ ] Add CNAME record for www pointing to EB CNAME
- [ ] (Optional) Setup root domain redirect or alias
- [ ] (Optional) Request ACM certificate
- [ ] (Optional) Configure HTTPS listener
- [ ] Wait for DNS propagation
- [ ] Test: `curl http://www.yourdomain.com`

---

## Need Help?

Run the automated setup script I'll create for you:
```bash
./setup-custom-domain.sh
```

Or manual AWS Route 53 setup:
1. Route 53 → Hosted Zones → Select your domain
2. Create Record → CNAME → www → EB URL
3. Wait 5-30 minutes for propagation
4. Done!


