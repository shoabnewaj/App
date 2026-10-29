#!/bin/bash
set -e

echo "=== 1. Setting up 2GB Swap ==="
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=2048
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile none swap sw 0 0" >> /etc/fstab
    echo "Swap enabled!"
fi
free -m

echo "=== 2. Installing Docker & Tools ==="
dnf update -y
dnf install -y docker git curl
systemctl enable --now docker
usermod -aG docker ec2-user

echo "=== 3. Installing Docker Compose ==="
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.29.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose

docker --version
docker compose version
echo "=== SERVER_SETUP_COMPLETE ==="
