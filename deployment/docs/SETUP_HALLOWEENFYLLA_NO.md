# Custom Domain Setup for halloweenfylla.no

## 📋 Quick Reference

**Your Domain**: halloweenfylla.no  
**EB Environment**: drikkeleken-prod  
**EB URL**: drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com  
**Region**: eu-north-1 (Stockholm)

---

## ✅ Step-by-Step Checklist

### Phase 1: Set Up Route 53 Hosted Zone

- [ ] **Step 1**: Open Route 53 Console
  - Link: https://console.aws.amazon.com/route53/v2/home#Dashboard
  - Or search for "Route 53" in AWS Console

- [ ] **Step 2**: Create Hosted Zone (if you don't have one)
  - Click "Hosted zones" in left sidebar
  - Click orange "Create hosted zone" button
  - Enter domain name: `halloweenfylla.no`
  - Type: Public hosted zone
  - Click "Create hosted zone"

- [ ] **Step 3**: Note the Nameservers
  - After creation, you'll see 4 NS (nameserver) records like:
    ```
    ns-123.awsdns-12.com
    ns-456.awsdns-45.net
    ns-789.awsdns-78.org
    ns-012.awsdns-01.co.uk
    ```
  - **IMPORTANT**: Copy these nameservers!

- [ ] **Step 4**: Update Nameservers at Your Domain Registrar
  - Go to where you bought halloweenfylla.no (GoDaddy, Namecheap, etc.)
  - Find DNS/Nameserver settings
  - Replace existing nameservers with the 4 Route 53 nameservers
  - Save changes
  - **Wait 1-24 hours for this to propagate**

---

### Phase 2: Create DNS Records (After Nameservers Propagate)

#### A. Create www.halloweenfylla.no Record

- [ ] **Step 5**: Create CNAME for www
  - In Route 53, click on your hosted zone (halloweenfylla.no)
  - Click "Create record"
  - Fill in:
    - **Record name**: `www`
    - **Record type**: CNAME
    - **Value**: `drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`
    - **TTL**: 300
    - **Routing policy**: Simple routing
  - Click "Create records"

#### B. Create Root Domain (halloweenfylla.no) Record

- [ ] **Step 6**: Create A Alias for root domain
  - Click "Create record" again
  - Fill in:
    - **Record name**: (leave blank)
    - **Record type**: A
    - **Alias**: Toggle to ON
    - **Route traffic to**: 
      - Choose "Alias to Elastic Beanstalk environment"
      - Region: EU (Stockholm) eu-north-1
      - Environment: drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com
    - Click "Create records"

---

### Phase 3: Wait and Test

- [ ] **Step 7**: Wait for DNS Propagation (5-60 minutes)

- [ ] **Step 8**: Test DNS Resolution
  ```bash
  nslookup www.halloweenfylla.no
  nslookup halloweenfylla.no
  ```

- [ ] **Step 9**: Test HTTP Access
  ```bash
  curl -I http://www.halloweenfylla.no
  curl -I http://halloweenfylla.no
  ```

- [ ] **Step 10**: Test in Browser
  - Visit: http://www.halloweenfylla.no
  - Visit: http://halloweenfylla.no
  - Both should show your app! 🎉

---

## 🔍 Troubleshooting

### Nameservers Not Updated Yet
**Test**: `nslookup -type=NS halloweenfylla.no`
- If you see your registrar's nameservers → Wait longer
- If you see Route 53 nameservers → Ready to create DNS records!

### DNS Not Resolving
- **Check**: https://dnschecker.org → Enter www.halloweenfylla.no
- Green checkmarks = propagated globally
- Red X = still propagating

### Site Not Loading
1. Check DNS: `nslookup www.halloweenfylla.no`
2. Check EB health: `eb health`
3. Check EB is accessible: `curl http://drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com`

---

## 🔒 Optional: Add HTTPS/SSL

### Option 1: AWS Certificate Manager (ACM)

- [ ] **Step 11**: Request Certificate
  - Go to: https://console.aws.amazon.com/acm/home?region=eu-north-1
  - Click "Request a certificate"
  - Choose "Request a public certificate"
  - Domain names:
    - `halloweenfylla.no`
    - `www.halloweenfylla.no`
  - Validation method: DNS validation
  - Click "Request"

- [ ] **Step 12**: Validate Certificate
  - ACM will show CNAME records to add
  - In Route 53, add those CNAME records
  - Wait 5-30 minutes for validation

- [ ] **Step 13**: Add Certificate to Load Balancer
  - Go to EB Console → drikkeleken-prod
  - Click "Configuration" → "Load balancer"
  - Click "Edit"
  - Click "Add listener"
    - Port: 443
    - Protocol: HTTPS
    - SSL certificate: Choose your ACM certificate
  - Click "Apply"
  - Wait for environment to update (5-10 minutes)

- [ ] **Step 14**: Test HTTPS
  ```bash
  curl -I https://www.halloweenfylla.no
  curl -I https://halloweenfylla.no
  ```

---

## 💰 Cost Summary

| Item | Cost |
|------|------|
| Route 53 Hosted Zone | $0.50/month |
| DNS Queries | ~$0.40 per million queries |
| ACM SSL Certificate | FREE |
| **Monthly Total** | ~$0.50-1.00/month |
| **Annual Total** | ~$6-12/year |

Plus your domain registration fee (~$12-15/year at your registrar)

---

## 📞 Quick Links

- **Route 53 Console**: https://console.aws.amazon.com/route53/
- **ACM Console** (eu-north-1): https://console.aws.amazon.com/acm/home?region=eu-north-1
- **EB Console**: https://console.aws.amazon.com/elasticbeanstalk/
- **DNS Checker**: https://dnschecker.org
- **Your Current App**: http://drikkeleken-prod.eba-5u8da7it.eu-north-1.elasticbeanstalk.com

---

## ✅ Success Criteria

You're done when:
- ✅ `nslookup www.halloweenfylla.no` returns an IP address
- ✅ `curl http://www.halloweenfylla.no` returns your app
- ✅ Browser shows your app at http://www.halloweenfylla.no
- ✅ (Optional) HTTPS works: https://www.halloweenfylla.no

---

## 🎯 Current Status

**Date**: October 30, 2025  
**Domain**: halloweenfylla.no  
**App Status**: ✅ Live on AWS  
**Custom Domain**: ⏳ Pending setup

**Next Action**: Follow the checklist above starting with Step 1!

---

**Estimated Total Setup Time**: 30-60 minutes (+ waiting for DNS propagation)

Good luck! 🎃👻🍻

