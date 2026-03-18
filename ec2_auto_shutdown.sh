#!/bin/bash

echo "Script started at $(date)" >> /home/ubuntu/script/debug.log

sleep 15

REGION="us-east-1"

TOKEN=$(curl -X PUT -s "http://169.254.169.254/latest/api/token" \
-H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
http://169.254.169.254/latest/meta-data/instance-id)

ACTIVE_USERS=$(who | wc -l)

echo "Active SSH sessions: $ACTIVE_USERS" >> /home/ubuntu/script/debug.log

if [ "$ACTIVE_USERS" -eq 0 ]; then
    echo "Stopping instance..." >> /home/ubuntu/script/debug.log
    aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION"
else
    echo "Still active users" >> /home/ubuntu/script/debug.log
fi
