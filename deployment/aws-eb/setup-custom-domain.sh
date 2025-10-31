#!/bin/bash

# Custom Domain Setup Script for AWS Elastic Beanstalk
# This script helps you set up a custom domain for your Drikkeleken app

set -e

echo "🎃 Drikkeleken - Custom Domain Setup 🎃"
echo ""

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "⚠️  AWS CLI not found. Install it for automated setup:"
    echo "   pip install awscli"
    echo ""
fi

# Get EB environment CNAME
echo "📋 Getting your Elastic Beanstalk environment details..."
EB_CNAME=$(eb status 2>/dev/null | grep "CNAME:" | awk '{print $2}')

if [ -z "$EB_CNAME" ]; then
    echo "❌ Could not find EB environment CNAME"
    echo "Run: eb status"
    exit 1
fi

echo "✅ Your EB environment URL: $EB_CNAME"
echo ""

# Menu
echo "Choose your domain setup method:"
echo "1) AWS Route 53 - Web Console (Recommended - No AWS CLI needed)"
echo "2) AWS Route 53 - Automated via CLI (Requires AWS CLI configuration)"
echo "3) External DNS Provider - Manual Instructions (Cloudflare, GoDaddy, etc.)"
echo "4) Show my EB URL only"
echo "5) Setup SSL Certificate (HTTPS)"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        echo ""
        echo "🌐 AWS Route 53 - Web Console Setup"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""

        read -p "Enter your domain name (e.g., drikkeleken.com): " DOMAIN

        if [ -z "$DOMAIN" ]; then
            echo "❌ Domain name required"
            exit 1
        fi

        echo ""
        echo "📋 Instructions for Route 53 Web Console:"
        echo ""
        echo "1. Open AWS Route 53 Console:"
        echo "   https://console.aws.amazon.com/route53/"
        echo ""
        echo "2. If you don't have a hosted zone for $DOMAIN yet:"
        echo "   • Click 'Hosted zones' → 'Create hosted zone'"
        echo "   • Domain name: $DOMAIN"
        echo "   • Type: Public hosted zone"
        echo "   • Click 'Create hosted zone'"
        echo "   • Update your domain's nameservers to the NS records shown"
        echo ""
        echo "3. Create DNS record for www.$DOMAIN:"
        echo "   • Click on your hosted zone ($DOMAIN)"
        echo "   • Click 'Create record'"
        echo "   • Record name: www"
        echo "   • Record type: CNAME"
        echo "   • Value: $EB_CNAME"
        echo "   • TTL: 300"
        echo "   • Click 'Create records'"
        echo ""
        echo "4. (Optional) Create DNS record for root domain ($DOMAIN):"
        echo "   • Click 'Create record'"
        echo "   • Leave record name blank (for root domain)"
        echo "   • Record type: A"
        echo "   • Toggle 'Alias' to ON"
        echo "   • Route traffic to: Alias to Elastic Beanstalk environment"
        echo "   • Region: EU (Stockholm) [eu-north-1]"
        echo "   • Select your environment: drikkeleken-prod"
        echo "   • Click 'Create records'"
        echo ""
        echo "5. Wait 5-60 minutes for DNS propagation"
        echo ""
        echo "6. Test your domain:"
        echo "   curl http://www.$DOMAIN"
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✅ Instructions complete!"
        echo ""
        echo "Your EB URL to use in DNS: $EB_CNAME"
        echo ""
        ;;

    2)
        echo ""
        echo "🌐 AWS Route 53 - Automated CLI Setup"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""

        # Check AWS credentials
        if ! aws sts get-caller-identity &>/dev/null; then
            echo "❌ AWS credentials not configured"
            echo ""
            echo "To configure AWS CLI:"
            echo "1. Run: aws configure"
            echo "2. Enter your AWS Access Key ID"
            echo "3. Enter your AWS Secret Access Key"
            echo "4. Enter your region (e.g., eu-north-1)"
            echo "5. Enter output format (json)"
            echo ""
            echo "Get credentials from AWS Console:"
            echo "https://console.aws.amazon.com/iam/home#/security_credentials"
            echo ""
            echo "Or use Option 1 for web console setup (no CLI needed)!"
            exit 1
        fi

        read -p "Enter your domain name (e.g., drikkeleken.com): " DOMAIN

        if [ -z "$DOMAIN" ]; then
            echo "❌ Domain name required"
            exit 1
        fi

        echo ""
        echo "Checking for hosted zone for $DOMAIN..."

        # Try to find hosted zone
        ZONE_ID=$(aws route53 list-hosted-zones --query "HostedZones[?Name=='${DOMAIN}.'].Id" --output text 2>/dev/null | cut -d'/' -f3)

        if [ -z "$ZONE_ID" ]; then
            echo "⚠️  No hosted zone found for $DOMAIN"
            echo ""
            echo "You need to:"
            echo "1. Go to AWS Route 53 Console"
            echo "2. Create a hosted zone for $DOMAIN"
            echo "3. Update your domain's nameservers to Route 53's nameservers"
            echo "4. Run this script again"
            echo ""
            echo "Or create hosted zone now via CLI:"
            echo "aws route53 create-hosted-zone --name $DOMAIN --caller-reference $(date +%s)"
            exit 1
        fi

        echo "✅ Found hosted zone: $ZONE_ID"
        echo ""

        read -p "Create DNS record for www.$DOMAIN? (y/n): " CREATE_WWW

        if [ "$CREATE_WWW" = "y" ]; then
            echo "Creating CNAME record for www.$DOMAIN → $EB_CNAME"

            # Create change batch JSON
            cat > /tmp/route53-change.json <<EOF
{
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "www.${DOMAIN}",
      "Type": "CNAME",
      "TTL": 300,
      "ResourceRecords": [{"Value": "${EB_CNAME}"}]
    }
  }]
}
EOF

            aws route53 change-resource-record-sets \
                --hosted-zone-id "$ZONE_ID" \
                --change-batch file:///tmp/route53-change.json

            rm /tmp/route53-change.json

            echo "✅ DNS record created for www.$DOMAIN"
            echo ""
            echo "Your site will be available at: http://www.$DOMAIN"
            echo "DNS propagation may take 5-60 minutes"
            echo ""
        fi

        read -p "Create DNS record for root domain ($DOMAIN)? (y/n): " CREATE_ROOT

        if [ "$CREATE_ROOT" = "y" ]; then
            echo ""
            echo "⚠️  For root domain, we need the Elastic Beanstalk Hosted Zone ID"
            echo "For eu-north-1 region, it's: Z23TAZ6LKFMNIO"
            echo ""
            read -p "Enter EB Hosted Zone ID (or press Enter for eu-north-1 default): " EB_ZONE_ID
            EB_ZONE_ID=${EB_ZONE_ID:-Z23TAZ6LKFMNIO}

            cat > /tmp/route53-alias.json <<EOF
{
  "Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "${DOMAIN}",
      "Type": "A",
      "AliasTarget": {
        "HostedZoneId": "${EB_ZONE_ID}",
        "DNSName": "${EB_CNAME}",
        "EvaluateTargetHealth": false
      }
    }
  }]
}
EOF

            aws route53 change-resource-record-sets \
                --hosted-zone-id "$ZONE_ID" \
                --change-batch file:///tmp/route53-alias.json

            rm /tmp/route53-alias.json

            echo "✅ DNS alias created for $DOMAIN"
            echo ""
        fi

        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "✅ DNS Setup Complete!"
        echo ""
        echo "Your site will be available at:"
        [ "$CREATE_WWW" = "y" ] && echo "  • http://www.$DOMAIN"
        [ "$CREATE_ROOT" = "y" ] && echo "  • http://$DOMAIN"
        echo ""
        echo "Wait 5-60 minutes for DNS propagation, then test:"
        [ "$CREATE_WWW" = "y" ] && echo "  curl http://www.$DOMAIN"
        [ "$CREATE_ROOT" = "y" ] && echo "  curl http://$DOMAIN"
        echo ""
        echo "Check DNS propagation: https://dnschecker.org"
        ;;

    3)
        echo ""
        echo "📝 Manual DNS Setup Instructions"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        read -p "Enter your domain name (e.g., drikkeleken.com): " DOMAIN
        echo ""
        echo "Instructions for setting up $DOMAIN:"
        echo ""
        echo "1. Login to your DNS provider (GoDaddy, Namecheap, Cloudflare, etc.)"
        echo "2. Go to DNS Management / DNS Settings"
        echo "3. Add a new CNAME record:"
        echo ""
        echo "   Type:   CNAME"
        echo "   Name:   www"
        echo "   Value:  $EB_CNAME"
        echo "   TTL:    300 (or Auto)"
        echo ""
        echo "4. (Optional) For root domain ($DOMAIN):"
        echo "   - If your provider supports CNAME flattening: Add CNAME @ → $EB_CNAME"
        echo "   - Otherwise: Setup a redirect from $DOMAIN to www.$DOMAIN"
        echo ""
        echo "5. Save changes and wait for DNS propagation (5-60 minutes)"
        echo ""
        echo "6. Test with: curl http://www.$DOMAIN"
        echo ""
        echo "Popular DNS Providers:"
        echo "  • Cloudflare: DNS → Add Record → CNAME"
        echo "  • GoDaddy: My Products → DNS → Add Record"
        echo "  • Namecheap: Domain → Advanced DNS → Add Record"
        echo ""
        ;;

    4)
        echo ""
        echo "📋 Your Elastic Beanstalk Information"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Environment URL (CNAME):"
        echo "  $EB_CNAME"
        echo ""
        echo "Full URL:"
        echo "  http://$EB_CNAME"
        echo ""
        echo "Health Check:"
        echo "  http://$EB_CNAME/health"
        echo ""
        ;;

    5)
        echo ""
        echo "🔒 SSL Certificate Setup (HTTPS)"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Option 1: AWS Certificate Manager (ACM) - FREE"
        echo "  1. Go to AWS ACM Console"
        echo "  2. Request a certificate → Public certificate"
        echo "  3. Domain names: yourdomain.com, www.yourdomain.com"
        echo "  4. Validation: DNS validation (easier with Route 53)"
        echo "  5. Add validation CNAME records to DNS"
        echo "  6. Wait for validation (5-30 minutes)"
        echo "  7. Go to EB Console → Configuration → Load Balancer"
        echo "  8. Add Listener: Port 443, HTTPS, Select certificate"
        echo "  9. Save and apply"
        echo ""
        echo "Option 2: Cloudflare SSL - FREE & INSTANT"
        echo "  1. Add your domain to Cloudflare"
        echo "  2. Update nameservers to Cloudflare"
        echo "  3. Add DNS record with Proxy enabled"
        echo "  4. SSL automatically enabled!"
        echo ""
        echo "Option 3: Let's Encrypt (Advanced)"
        echo "  Requires certbot and EB configuration"
        echo "  Not recommended for beginners"
        echo ""
        ;;

    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 For detailed instructions, see: CUSTOM_DOMAIN_SETUP.md"
echo "✨ Done!"

