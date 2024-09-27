#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Update and upgrade the system
apt-get update -y
apt-get upgrade -y

# Export environment variables (for OPENWEATHER_API_KEY and SMTP_AUTH_PASSWORD)
echo "export OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY}" >> /etc/profile
echo "export SMTP_AUTH_PASSWORD=${SMTP_AUTH_PASSWORD}" >> /etc/profile

# Log the exported variables (for verification purposes)
echo "OPENWEATHER_API_KEY=${OPENWEATHER_API_KEY}" >> /var/log/user-data.log
echo "SMTP_AUTH_PASSWORD=${SMTP_AUTH_PASSWORD}" >> /var/log/user-data.log

# Install required packages
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

# Add ubuntu user to the docker group so it can run Docker without sudo
usermod -aG docker ubuntu

# Install Docker Compose (Standalone)
curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Clone the repository where the monitoring setup and Docker Compose files are located
cd /home/ubuntu
git clone https://github.com/Matanmoshes/sre-monitoring-setup.git

# Change ownership of the cloned repository to the ubuntu user
chown -R ubuntu:ubuntu sre-monitoring-setup

# Navigate to the monitoring folder where docker-compose.yml and other related files are located
cd sre-monitoring-setup/monitoring

# Create necessary directories for volume mounts (Prometheus and Grafana)
mkdir -p prometheus-data grafana-data

# Ensure ubuntu user owns these directories
chown -R ubuntu:ubuntu prometheus-data grafana-data

# Start Docker Compose to bring up the entire monitoring stack
sudo -H -u ubuntu docker-compose up -d
