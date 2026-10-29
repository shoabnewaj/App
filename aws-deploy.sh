#!/bin/bash
# ==============================================================================
# Y-ChatApp Automated Cloud & Server Deployment Script
# Compatible with Ubuntu / Debian (apt) AND Amazon Linux / RHEL / CentOS (dnf/yum)
# ==============================================================================

set -e

echo "=================================================="
echo "   Starting Y-ChatApp Server Auto Deploy          "
echo "=================================================="

# 1. Setup 2GB Swap Memory (Crucial for 1GB RAM Free Tier instances)
if [ ! -f /swapfile ]; then
    echo "Creating 2GB Swap Memory..."
    sudo fallocate -l 2G /swapfile || sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    echo "Swap memory enabled successfully!"
else
    echo "Swap memory already present."
fi

# 2. Install Docker & Docker Compose if not installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    if command -v dnf &> /dev/null; then
        sudo dnf install -y docker git --allowerasing
    elif command -v yum &> /dev/null; then
        sudo yum install -y docker git
    elif command -v apt-get &> /dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y ca-certificates curl gnupg lsb-release git
        curl -fsSL https://get.docker.com | sudo sh
    fi
    sudo usermod -aG docker $USER || true
    echo "Docker installed successfully!"
fi

# 3. Start Docker Service
sudo systemctl enable --now docker

# 4. Ensure Docker Compose plugin is installed
if ! sudo docker compose version &> /dev/null; then
    echo "Installing Docker Compose v2 plugin..."
    sudo mkdir -p /usr/local/lib/docker/cli-plugins
    sudo curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
    sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
    sudo ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose
fi

# 5. Build & Launch Containers
echo "Building and starting Y-ChatApp & MySQL containers..."
sudo docker compose down || true
sudo docker compose up -d --build

# 6. Wait for Containers
echo "Waiting for containers to start..."
sleep 10
sudo docker compose ps

# 7. Print Server Public IP
PUBLIC_IP=$(curl -s http://checkip.amazonaws.com || curl -s ifconfig.me || echo "localhost")

echo "=================================================="
echo "DEPLOYMENT COMPLETE!"
echo "Your app is now LIVE online at:"
echo "  http://${PUBLIC_IP}"
echo "  http://${PUBLIC_IP}:8080"
echo "=================================================="
