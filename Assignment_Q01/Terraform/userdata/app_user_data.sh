#!/bin/bash
set -e

# Update package list and install Apache
sudo apt-get update
sudo apt-get install -y apache2

# Enable and start Apache service
sudo systemctl enable apache2
sudo systemctl start apache2

# Check Apache status
sudo systemctl status apache2
