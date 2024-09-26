#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Update the system
apt-get update -y
apt-get upgrade -y

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

# Start Docker service
systemctl start docker
systemctl enable docker

# Add ubuntu user to the docker group
usermod -aG docker ubuntu

# Install Docker Compose (Standalone)
curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create necessary directories for volume mounts
mkdir -p prometheus-data grafana-data

# Ensure ubuntu user owns these directories
chown -R ubuntu:ubuntu prometheus-data grafana-data

# Start Docker Compose as ubuntu user
sudo -H -u ubuntu docker-compose up -d
