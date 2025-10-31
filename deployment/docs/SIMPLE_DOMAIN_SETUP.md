# Simple Custom Domain Setup (No AWS CLI Needed!)

## 🎯 Easiest Method: Use Cloudflare (Recommended)

**Why Cloudflare?**
- ✅ No AWS CLI needed
- ✅ FREE SSL certificate (instant HTTPS!)
- ✅ Simple web interface
- ✅ Works with any domain registrar
- ✅ FREE forever

### Step-by-Step Guide

#### 1. Get Your EB URL
```bash
./setup-custom-domain.sh
# Choose option 4 to see your EB URL
```

Your EB URL: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

#### 2. Buy a Domain (if you don't have one)
- GoDaddy: https://godaddy.com (~$12/year)
- Namecheap: https://namecheap.com (~$9/year)
- Google Domains: https://domains.google (~$12/year)
- Any registrar works!

#### 3. Sign Up for Cloudflare (FREE)
- Go to: https://cloudflare.com
- Create free account
- Click "Add a Site"
- Enter your domain name

#### 4. Change Nameservers
Cloudflare will show you 2 nameservers like:
```
ada.ns.cloudflare.com
seth.ns.cloudflare.com
```

Go to your domain registrar and update nameservers:
- **GoDaddy**: My Products → Domain → Manage DNS → Nameservers → Change
- **Namecheap**: Domain List → Manage → Nameservers → Custom DNS
- **Google Domains**: DNS → Name servers → Use custom name servers

Enter the Cloudflare nameservers and save.

#### 5. Add DNS Record in Cloudflare
1. In Cloudflare dashboard, click "DNS"
2. Click "Add record"
3. Fill in:
   - **Type**: CNAME
   - **Name**: www (or @ for root domain)
   - **Target**: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
   - **Proxy status**: **Proxied** (🟠 orange cloud) ← IMPORTANT for free SSL!
   - **TTL**: Auto
4. Click "Save"

#### 6. Wait & Test
- **Wait**: 5-30 minutes (nameserver change can take up to 24 hours)
- **Test**: Visit `https://www.yourdomain.com`
- **Verify SSL**: Look for the padlock 🔒 in your browser

✅ Done! You now have HTTPS for FREE!

---

## 🌐 Alternative: AWS Route 53 (Web Console)

**Use this if you prefer to keep everything in AWS.**

### Step-by-Step Guide

#### 1. Get Your EB URL
```bash
eb status | grep CNAME
```
Copy the URL: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

#### 2. Open Route 53 Console
Go to: https://console.aws.amazon.com/route53/

#### 3. Create Hosted Zone (if you don't have one)
1. Click "Hosted zones"
2. Click "Create hosted zone"
3. Enter your domain name (e.g., `yourdomain.com`)
4. Type: Public hosted zone
5. Click "Create hosted zone"
6. **IMPORTANT**: Copy the 4 nameserver (NS) records shown
7. Update your domain's nameservers at your registrar to use these NS records

#### 4. Create DNS Record for www
1. Click on your hosted zone name
2. Click "Create record"
3. Fill in:
   - **Record name**: www
   - **Record type**: CNAME
   - **Value**: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
   - **TTL**: 300
4. Click "Create records"

#### 5. Create DNS Record for Root Domain (Optional)
1. Click "Create record"
2. Fill in:
   - **Record name**: (leave blank)
   - **Record type**: A
   - **Alias**: Toggle ON
   - **Route traffic to**: Alias to Elastic Beanstalk environment
   - **Region**: EU (Stockholm) [eu-north-1]
   - **Choose environment**: drikkeleken-prod
3. Click "Create records"

#### 6. Wait & Test
- **Wait**: 5-60 minutes
- **Test**: `curl http://www.yourdomain.com`

**Cost**: $0.50/month for hosted zone + $12-15/year for domain

---

## 🏷️ Other DNS Providers (Manual Setup)

### GoDaddy
1. Login to GoDaddy
2. My Products → Domain → Manage DNS
3. Add Record:
   - Type: CNAME
   - Name: www
   - Value: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
   - TTL: 600

### Namecheap
1. Login to Namecheap
2. Domain List → Manage → Advanced DNS
3. Add New Record:
   - Type: CNAME Record
   - Host: www
   - Value: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
   - TTL: Automatic

### Google Domains
1. Login to Google Domains
2. DNS → Custom records
3. Add:
   - Name: www
   - Type: CNAME
   - Data: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
   - TTL: 1H

---

## ✅ Verification

After DNS propagates, test:

```bash
# Check DNS resolution
nslookup www.yourdomain.com

# Test HTTP
curl http://www.yourdomain.com

# Test HTTPS (if using Cloudflare or SSL)
curl https://www.yourdomain.com

# Check health endpoint
curl http://www.yourdomain.com/health
```

Check propagation status: https://dnschecker.org

---

## 💰 Cost Comparison

| Method | Setup Cost | Annual Cost | SSL | Difficulty |
|--------|------------|-------------|-----|------------|
| **Cloudflare** | FREE | $12-15 (domain only) | FREE | ⭐ Easy |
| **Route 53** | FREE | $18-21 (domain + $6/year) | FREE (ACM) | ⭐⭐ Medium |
| **Other DNS** | FREE | $12-15 (domain only) | Paid or ACM | ⭐⭐ Medium |

---

## 🎯 Recommendation

**For beginners**: Use **Cloudflare**
- Easiest setup
- Free SSL
- Best value
- No AWS CLI needed

**For AWS-centric users**: Use **Route 53**
- Everything in one place
- Native AWS integration
- Professional setup

---

## 🆘 Need Help?

Run the interactive script:
```bash
./setup-custom-domain.sh
```

Choose option 1 for Route 53 web console instructions (no AWS CLI needed!)
Choose option 3 for external DNS provider instructions (Cloudflare, GoDaddy, etc.)

---

**No AWS CLI configuration needed for any of these methods!** 🎉

