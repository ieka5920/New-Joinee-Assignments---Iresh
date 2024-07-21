#!/bin/bash
set -e

# Add Jenkins keyring and repository
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package list and install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Install Java and other necessary packages
sudo apt-get update
sudo apt-get install -y fontconfig openjdk-17-jre

# Verify Java installation
java -version

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Output Jenkins admin password
admin_password=$(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)

# # Store Jenkins admin password in SSM Parameter Store
# aws ssm put-parameter --name "/jenkins/admin_password" --value "$admin_password" --type "SecureString" --overwrite --region $AWS_DEFAULT_REGION

# Check Jenkins status
sudo systemctl status jenkins
