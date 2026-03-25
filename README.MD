#  EC2 Auto Shutdown on SSH Logout (EVENT-DRIVEN AUTOMATION)

## Overview

This project automates the shutdown of an AWS EC2 instance when no active SSH sessions are detected. It was built to solve a real-world problem encountered during hands-on DevOps practice.

## Problem Faced

While working with AWS EC2 instances during DevOps training, I frequently connected to instances via SSH to run commands and test configurations.

After completing my work and disconnecting, I often forgot to manually stop the EC2 instance.

Since EC2 instances continue running even after SSH sessions end, this can lead to:

- Unnecessary AWS compute costs  
- Poor resource management  
- Reliance on manual intervention  

## Solution

To eliminate this issue, I developed a Bash automation script that:

- Monitors active SSH sessions on the instance  
- Confirms when no users are connected  
- Retrieves the EC2 instance ID securely using AWS IMDSv2  
- Automatically stops the instance using AWS CLI  
- Logs all actions for debugging and visibility  

This ensures the instance shuts down only when it is no longer in use.

## How It Works

### Step 1 — Log Script Execution

echo "Script started at $(date)" >> /home/ubuntu/script/debug.log

- Records when the script runs  
- Helps with debugging and tracking  

### Step 2 — Initial Delay

sleep 5

- Waits briefly before executing logic  
- Prevents false triggers from quick disconnects  

### Step 3 — Define AWS Region

REGION="us-east-1"

- Specifies the region for AWS CLI commands  

### Step 4 — Retrieve Metadata Token (IMDSv2)

TOKEN=$(curl -X PUT -s "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

- Requests a secure token from the EC2 metadata service  

### Step 5 — Retrieve Instance ID

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)

- Dynamically retrieves the EC2 instance ID  
- Avoids hardcoding values  

### Step 6 — Check Active SSH Sessions

ACTIVE_USERS=$(who | wc -l)

- Counts number of logged-in users  
- Determines if the instance is still in use  

### Step 7 — Log Active Sessions

echo "Active SSH sessions: $ACTIVE_USERS" >> /home/ubuntu/script/debug.log

- Records session activity for visibility  

### Step 8 — Detect Potential Logout

if [ "$ACTIVE_USERS" -le 1 ]; then

- If 1 or fewer users → possible last session  
- Prevents shutting down when multiple users are connected  

### Step 9 — Verification Delay

sleep 10

- Waits before taking action  
- Ensures user didn’t reconnect  

### Step 10 — Recheck Active Sessions

ACTIVE_USERS=$(who | wc -l)

- Confirms whether instance is still idle  

### Step 11 — Stop EC2 Instance

aws ec2 stop-instances --instance-ids "$INSTANCE_ID" --region "$REGION"

- Stops the EC2 instance using AWS CLI  
- Prevents unnecessary costs  

### Step 12 — Log Shutdown

echo "Shutdown command executed." >> /home/ubuntu/script/debug.log

- Confirms shutdown action  

### Step 13 — Handle Reconnection

echo "User reconnected. Shutdown cancelled." >> /home/ubuntu/script/debug.log

- Cancels shutdown if a user reconnects  

### Step 14 — Handle Active Users

echo "Still active users" >> /home/ubuntu/script/debug.log

- Keeps instance running if users are still connected  

## Project Workflow

User connects via SSH  
↓  
User completes work and disconnects  
↓  
Script checks active SSH sessions  
↓  
If sessions ≤ 1 → wait 10 seconds  
↓  
Recheck sessions  
↓  
If still ≤ 1 → retrieve instance ID  
↓  
Execute AWS CLI stop command  
↓  
EC2 instance shuts down  

## Technologies Used

- AWS EC2  
- AWS CLI  
- Bash Scripting  
- Linux System Commands  
- IMDSv2 Metadata Service  
- Git & GitHub  

## Key Benefits

- Eliminates the need to manually stop EC2 instances  
- Reduces unnecessary AWS costs  
- Improves resource management  
- Demonstrates real-world DevOps automation  

##  Author

Dan Herete Agha  
DevOps & Cloud Engineering (Hands-on Projects)  

📍 Ontario, Canada  
📧 danheret@gmail.com  

🔗 LinkedIn:  
https://www.linkedin.com/in/danherete-agha-61104a283  

🔗 GitHub:  
https://github.com/Dan1234443  

## Notes

This project was built as part of hands-on DevOps practice, focusing on solving real-world problems through automation.

The goal was to automate EC2 instance management while strengthening my understanding of Linux systems, AWS services, and scripting for operational efficiency.
