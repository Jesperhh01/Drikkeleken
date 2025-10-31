#!/bin/bash

# Deployment script for AWS Elastic Beanstalk
# This script helps prepare and deploy your application

set -e

echo "🎃 Drikkeleken - AWS Elastic Beanstalk Deployment Script 🎃"
echo ""

# Check if EB CLI is installed
if ! command -v eb &> /dev/null; then
    echo "❌ EB CLI not found. Installing..."
    pip install awsebcli
fi

# Function to backup current requirements
backup_requirements() {
    if [ -f "requirements.txt" ]; then
        echo "📦 Backing up current requirements.txt to requirements-full.txt"
        cp requirements.txt requirements-full.txt
    fi
}

# Function to use production requirements
use_production_requirements() {
    echo "📦 Using production requirements..."
    cp requirements-production.txt requirements.txt
}

# Function to restore full requirements
restore_requirements() {
    if [ -f "requirements-full.txt" ]; then
        echo "📦 Restoring full requirements.txt"
        cp requirements-full.txt requirements.txt
    fi
}

# Menu
echo "Select deployment action:"
echo "1) Initialize EB (first time only)"
echo "2) Create environment"
echo "3) Deploy application"
echo "4) Check status"
echo "5) View logs"
echo "6) Open application"
echo "7) Set environment variables"
echo "8) Terminate environment"
echo ""
read -p "Enter choice [1-8]: " choice

case $choice in
    1)
        echo "🚀 Initializing Elastic Beanstalk..."
        echo ""
        echo "⚠️  IMPORTANT: When asked about CodeCommit, answer 'n' (No)"
        echo "   This will avoid CodeCommit errors."
        echo ""
        read -p "Press Enter to continue..."
        eb init
        ;;
    2)
        echo "🏗️  Creating environment..."
        read -p "Environment name (default: drikkeleken-prod): " env_name
        env_name=${env_name:-drikkeleken-prod}

        backup_requirements
        use_production_requirements

        eb create $env_name --instance-type t3.micro --single

        restore_requirements
        ;;
    3)
        echo "📤 Deploying application..."

        backup_requirements
        use_production_requirements

        eb deploy

        restore_requirements
        echo "✅ Deployment complete!"
        ;;
    4)
        echo "📊 Checking status..."
        eb status
        ;;
    5)
        echo "📋 Viewing logs..."
        eb logs
        ;;
    6)
        echo "🌐 Opening application..."
        eb open
        ;;
    7)
        echo "🔑 Setting environment variables..."
        echo ""
        echo "Example variables to set:"
        echo "  SECRET_KEY - Your Flask secret key"
        echo "  FLASK_ENV - production"
        echo ""
        read -p "Variable name: " var_name
        read -p "Variable value: " var_value

        if [ ! -z "$var_name" ] && [ ! -z "$var_value" ]; then
            eb setenv $var_name="$var_value"
            echo "✅ Environment variable set!"
        else
            echo "❌ Invalid input"
        fi
        ;;
    8)
        echo "⚠️  Terminating environment..."
        read -p "Are you sure? This will delete everything! (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            eb terminate
        else
            echo "Cancelled."
        fi
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✨ Done!"

