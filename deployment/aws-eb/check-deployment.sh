#!/bin/bash
# Pre-deployment checklist script

echo "🎃 Drikkeleken - AWS EB Deployment Checklist 🎃"
echo ""

check_passed=0
check_failed=0

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo "✅ $1"
        ((check_passed++))
        return 0
    else
        echo "❌ $1 - MISSING"
        ((check_failed++))
        return 1
    fi
}

# Function to check if directory exists
check_dir() {
    if [ -d "$1" ]; then
        echo "✅ $1/"
        ((check_passed++))
        return 0
    else
        echo "❌ $1/ - MISSING"
        ((check_failed++))
        return 1
    fi
}

# Function to check if command exists
check_command() {
    if command -v "$1" &> /dev/null; then
        echo "✅ $1 is installed"
        ((check_passed++))
        return 0
    else
        echo "❌ $1 is NOT installed"
        ((check_failed++))
        return 1
    fi
}

echo "📁 Checking Required Files..."
check_file "application.py"
check_file "Procfile"
check_file "runtime.txt"
check_file "requirements-production.txt"
check_file ".ebignore"
check_file "deploy.sh"

echo ""
echo "📂 Checking Configuration Directories..."
check_dir ".ebextensions"
check_file ".ebextensions/python.config"
check_file ".ebextensions/01_packages.config"
check_file ".ebextensions/02_environment.config"

echo ""
echo "🔧 Checking Required Tools..."
check_command "python3"
check_command "pip"
check_command "aws"
check_command "eb"

echo ""
echo "📋 Checking Application Files..."
check_dir "app"
check_file "app/__init__.py"
check_dir "app/routes"
check_file "app/routes/main.py"
check_dir "app/static"
check_dir "app/templates"

echo ""
echo "═══════════════════════════════════════"
echo "Summary: $check_passed passed, $check_failed failed"
echo "═══════════════════════════════════════"

if [ $check_failed -eq 0 ]; then
    echo ""
    echo "🎉 All checks passed! Ready for deployment!"
    echo ""
    echo "Next steps:"
    echo "1. Run: ./deploy.sh"
    echo "2. Select option 1 to initialize (if first time)"
    echo "3. Select option 2 to create environment"
    echo "4. Select option 3 to deploy"
    echo ""
    exit 0
else
    echo ""
    echo "⚠️  Some checks failed. Please fix the issues above."
    echo ""

    if ! command -v eb &> /dev/null; then
        echo "To install EB CLI: pip install awsebcli"
    fi

    if ! command -v aws &> /dev/null; then
        echo "To install AWS CLI: pip install awscli"
        echo "Then configure: aws configure"
    fi

    echo ""
    exit 1
fi

