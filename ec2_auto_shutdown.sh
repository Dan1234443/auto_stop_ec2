#!/bin/bash

# Author: Dan-Herete Agha
# Project: EC2 Auto Shutdown Script
# Description: Automatically stops EC2 instance when SSH sessions ends

# Count active SSH sessions
ACTIVE_USERS=$(who | grep pts | wc -l)

echo "Active SSH sessions: $ACTIVE_USERS"

# Get IMDSv2 token
TOKEN=$(curl -X PUT -s "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Get EC2 instance ID
INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

REGION="us-east-1"

# If no active SSH sessions remain
if [ "$ACTIVE_USERS" -eq 0 ]; then
    echo "No active SSH sessions detected."

    # Safety delay
    sleep 60

    ACTIVE_USERS=$(who | grep pts | wc -l)

    if [ "$ACTIVE_USERS" -eq 0 ]; then
        echo "Stopping EC2 instance..."
        aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION"
    else
        echo "User logged in again. Shutdown cancelled."
    fi
else
    echo "Users still logged in. Instance stays running."
fi
