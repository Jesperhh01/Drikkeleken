#!/bin/bash

# Helper script to wait for EB environment to be ready

echo "🎃 Checking if environment is ready for deployment..."
echo ""

# Check if EB is initialized
if [ ! -d ".elasticbeanstalk" ]; then
    echo "❌ Elastic Beanstalk not initialized."
    echo "Run: eb init"
    exit 1
fi

# Get environment status
STATUS=$(eb status 2>/dev/null | grep "Status:" | awk '{print $2}')
HEALTH=$(eb status 2>/dev/null | grep "Health:" | awk '{print $2}')

echo "Current Status: $STATUS"
echo "Current Health: $HEALTH"
echo ""

if [ "$STATUS" = "Ready" ]; then
    if [ "$HEALTH" = "Green" ] || [ "$HEALTH" = "Ok" ]; then
        echo "✅ Environment is READY for deployment!"
        echo ""
        echo "You can now run:"
        echo "  eb deploy"
        echo ""
        exit 0
    else
        echo "⚠️  Environment is Ready but Health is $HEALTH"
        echo ""
        echo "Wait a bit longer and check again with:"
        echo "  ./wait-for-ready.sh"
        echo ""
        exit 1
    fi
elif [ "$STATUS" = "Launching" ] || [ "$STATUS" = "Updating" ] || [ "$STATUS" = "Pending" ]; then
    echo "⏳ Environment is still $STATUS..."
    echo ""
    echo "Please wait. This usually takes 5-10 minutes."
    echo ""
    echo "To monitor progress:"
    echo "  eb health          (interactive)"
    echo "  eb status          (quick check)"
    echo "  ./wait-for-ready.sh   (run this script again)"
    echo ""
    exit 1
else
    echo "❌ Environment status: $STATUS"
    echo ""
    echo "Check what's wrong:"
    echo "  eb status"
    echo "  eb logs"
    echo ""
    exit 1
fi

