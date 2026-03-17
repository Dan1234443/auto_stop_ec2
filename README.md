# AWS EC2 Auto Shutdown After SSH Session Ends

##Overview

This project automates the shutdown of an AWS EC2 instance when no active SSH sessions are detected. It was built to solve a real-world problem encountered during hands-on DevOps practice.

---

##  Problem faced

While working with AWS EC2 instances during DevOps training, I frequently connected to instances via SSH to run commands and test configurations.

After completing my work and disconnecting, I often forgot to manually stop the EC2 instance.

Since EC2 instances continue running even after SSH sessions end, this can lead to:

- Unnecessary AWS compute costs  
- Poor resource management  
- Reliance on manual intervention  

---

##  Solution

To eliminate this issue, I developed a Bash automation script that:

1. Monitors active SSH sessions on the instance  
2. Confirms when no users are connected  
3. Retrieves the EC2 instance ID securely using AWS IMDSv2  
4. Automatically stops the instance using AWS CLI  

This ensures the instance shuts down **only when it is no longer in use**.

---

##  How It Works

### Step 1 — Detect Active SSH Sessions

    who | grep pts | wc -l

- Counts the number of active SSH sessions  
- Ensures we don’t shut down while someone is still connected  

---

### Step 2 — Add Safety Delay

    sleep 60

- Waits 60 seconds before taking action  
- Prevents accidental shutdown if a user reconnects  

---

### Step 3 — Recheck Active Sessions

- Confirms that no new SSH sessions started during the delay  
- Adds reliability to the automation  

---

### Step 4 — Retrieve Instance Metadata (IMDSv2)

    TOKEN=$(curl -X PUT -s "http://169.254.169.254/latest/api/token" \
    -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

    INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
    http://169.254.169.254/latest/meta-data/instance-id)

- Securely retrieves the EC2 instance ID  
- Uses IMDSv2 for improved security  

---

### Step 5 — Stop the EC2 Instance

    aws ec2 stop-instances --instance-ids $INSTANCE_ID --region us-east-1

- Uses AWS CLI to stop the instance  
- Prevents unnecessary compute costs  

---

## Project Workflow

    User connects via SSH
            ↓
    User completes work and disconnects
            ↓
    Script checks active SSH sessions
            ↓
    If sessions = 0 → wait 60 seconds
            ↓
    Recheck sessions
            ↓
    If still 0 → retrieve instance ID
            ↓
    Execute AWS CLI stop command
            ↓
    EC2 instance shuts down

---

##Technologies Used

- AWS EC2  
- AWS CLI  
- Bash Scripting  
- Linux System Commands  
- IMDSv2 Metadata Service  
- Git & GitHub  

---

##Key Benefits

- Eliminates the need to manually stop EC2 instances  
- Reduces unnecessary AWS costs  
- Improves resource management  
- Demonstrates automation in a real-world DevOps scenario  

---

## 👤 Author

**Dan-Herete Agha**  
DevOps & Cloud Engineering (Hands-on Projects)  

📍 Ontario, Canada  
📧 danheret@gmail.com  

🔗 LinkedIn:  
https://www.linkedin.com/in/danherete-agha-61104a283  

🔗 GitHub:  
https://github.com/Dan1234443  

---

## Notes

This project was built as part of hands-on DevOps practice, focusing on solving real-world problems through automation.

The goal was not only to automate EC2 instance management but also to develop a deeper understanding of Linux systems, AWS services, and scripting for operational efficiency.
