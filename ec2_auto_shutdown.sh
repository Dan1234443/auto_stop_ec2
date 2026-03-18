#!/bin/bash

# Wait for logout to complete
sleep 10

# Count sessions
ACTIVE_USERS=$(pgrep -u ubuntu sshd | wc -l)

echo "Active SSH sessions: $ACTIVE_USERS"

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
