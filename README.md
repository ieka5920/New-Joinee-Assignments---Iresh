
# Onboarding Assignments

This repository contains the completed onboarding assignments for CI/CD with Jenkins, Windows and PowerShell, and Python with AWS.

## Assignment_Q01: CI/CD with Jenkins

### Goal
- Get familiarized with CI/CD and Jenkins.
- Create a fully automated build pipeline to build and deploy code.

### Scenario
- Use default Apache installation and its `index.html` to demonstrate the pipeline.
- Modify the `index.html` and publish to the "dev" branch.
- Trigger the build job to put files into an artifact repository or S3 bucket.
- Upon success, trigger the deploy job to get the latest files into the app server and restart Apache.
- Publish the status code of the Apache web page as the outcome of the deploy job.

### Optional
- Integrate with SonarQube to run a static code analysis and pass the build based on that to trigger the deploy job.

## Assignment_Q02: Windows and PowerShell

### Goal
- Gain hands-on experience with Windows and PowerShell.

### Tasks
- Create a scheduled task using PowerShell to:
  - Create a log directory and add some sample log files to it.
  - Write a script to remove log files older than x days, output the list of deleted files to a file, and calculate the freed storage percentage.
  - Publish this file to an S3 bucket.
- Save the script as `logCleanup.ps1`.
- Create another script to provision the scheduled task using PowerShell.

## Assignment_Q03: Python with AWS

### Goal
- Improve knowledge of Python with AWS.

### Task
- Create a Lambda function in Python to generate a report listing all EC2 instances and their security group rules in a summary format.

### Example Report

| Instance ID         | Port/Port Range | Source    |
|---------------------|------------------|-----------|
| i-0babcd139754c2a28 | 8080--8080       | 0.0.0.0/0 |
| i-07604ae5b872269f4 | 80--80           | 0.0.0.0/0 |
| i-023694c1aabadde9e | 9000--9000       | 0.0.0.0/0 |

## Repository Structure
```
- Assignment_Q01/
  - Jenkins pipeline scripts and configuration
- Assignment_Q02/
  - logCleanup.ps1
  - Scheduled task provisioning script
- Assignment_Q03/
  - Lambda function code and configuration
```

## Submission
Please find the completed assignments in their respective directories. 
