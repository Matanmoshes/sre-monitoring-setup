#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Log the start of the user data script
echo "User data script started at $(date)" >> /var/log/user-data.log

# Export environment variables for Docker Compose
echo "export OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY}" >> /etc/profile
echo "export SMTP_AUTH_PASSWORD=${SMTP_AUTH_PASSWORD}" >> /etc/profile

# Log the environment variables for debugging (Remove in production)
echo "OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY}" >> /var/log/user-data.log
echo "SMTP_AUTH_PASSWORD=${SMTP_AUTH_PASSWORD}" >> /var/log/user-data.log

# Install required packages
apt-get update -y
apt-get upgrade -y
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git

# Install Docker
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker service and enable it on boot
systemctl start docker
systemctl enable docker

# Add ubuntu user to the docker group
usermod -aG docker ubuntu

# Install Docker Compose (Standalone)
curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone the repository where Docker Compose and related files are located
sudo -H -u ubuntu git clone https://github.com/Matanmoshes/sre-monitoring-setup.git /home/ubuntu/sre-monitoring-setup

# Change ownership of the cloned repository
chown -R ubuntu:ubuntu /home/ubuntu/sre-monitoring-setup

# Navigate to the monitoring directory
cd /home/ubuntu/sre-monitoring-setup/monitoring

# Create necessary directories for Prometheus and Grafana data volumes
mkdir -p prometheus-data grafana-data

# Ensure ubuntu user owns these directories
chown -R ubuntu:ubuntu prometheus-data grafana-data

# Run Docker Compose as ubuntu user with environment variables
sudo -H -u ubuntu bash -c "OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY} SMTP_AUTH_PASSWORD=${SMTP_AUTH_PASSWORD} docker-compose up -d"

# Log the completion of the user data script
echo "User data script completed at $(date)" >> /var/log/user-data.log
