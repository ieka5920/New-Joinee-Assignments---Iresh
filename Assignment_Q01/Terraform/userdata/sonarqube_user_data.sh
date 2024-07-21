#!/bin/bash
set -e

# Update and upgrade packages
sudo apt update
sudo apt upgrade -y

# Install OpenJDK 17
sudo apt install -y openjdk-17-jdk

# Verify Java installation
java -version

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

# Install PostgreSQL
sudo apt update
sudo apt install -y postgresql postgresql-contrib

# Enable and start PostgreSQL
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Verify PostgreSQL installation
sudo systemctl status postgresql

# Configure PostgreSQL
sudo -i -u postgres psql -c "CREATE USER ddsonar WITH ENCRYPTED PASSWORD 'mwd#2%#!!#%rgs';"
sudo -i -u postgres psql -c "CREATE DATABASE ddsonarqube OWNER ddsonar;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ddsonarqube TO ddsonar;"

# Install zip utility
sudo apt install -y zip

# Download and unzip SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip
sudo unzip sonarqube-10.0.0.68432.zip -d /opt/
sudo mv /opt/sonarqube-10.0.0.68432 /opt/sonarqube

# Create SonarQube group and user
sudo groupadd ddsonar
sudo useradd -d /opt/sonarqube -g ddsonar ddsonar
sudo chown -R ddsonar:ddsonar /opt/sonarqube

# Configure SonarQube database settings
sudo bash -c 'cat <<EOT >> /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=ddsonar
sonar.jdbc.password=mwd#2%#!!#%rgs
sonar.jdbc.url=jdbc:postgresql://localhost:5432/ddsonarqube
EOT'

# Set the RUN_AS_USER property
sudo bash -c 'echo "RUN_AS_USER=ddsonar" >> /opt/sonarqube/bin/linux-x86-64/sonar.sh'

# Create systemd service for SonarQube
sudo bash -c 'cat <<EOT > /etc/systemd/system/sonar.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=ddsonar
Group=ddsonar
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT'

# Configure system limits
sudo bash -c 'cat <<EOT >> /etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
EOT'

# Enable and start the SonarQube service
sudo systemctl enable sonar
sudo systemctl start sonar

# Apply system settings and reboot
sudo sysctl -p
sudo reboot
