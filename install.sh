#!/bin/bash

set -e

# -- Usage -- #
# ./setup.sh         -> CLI/server mode (no UI apps)
# ./setup.sh --ui    -> Full desktop mode (includes Discord, VLC, etc.)

UI_MODE=false
for arg in "$@"; do
  [[ "$arg" == "--ui" ]] && UI_MODE=true
done

echo "Starting setup (UI mode: $UI_MODE)..."

# -- System -- #
sudo apt update && sudo apt upgrade -y

# -- Core tools -- #
sudo apt install -y \
  curl \
  git \
  build-essential \
  ufw \
  snapd

# -- Languages -- #

# Java 11
sudo apt install -y openjdk-11-jdk

# Python
sudo apt install -y python3 python3-pip

# AWS CLI
pip3 install awscli --break-system-packages
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Node via NVM (better than apt — lets you manage versions)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts

# -- Nginx -- #
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo apt install -y certbot python3-certbot-nginx

# -- Play Framework -- #
# Scala build tool (sbt)
echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | sudo tee /etc/apt/sources.list.d/sbt.list
curl -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | sudo apt-key add -
sudo apt update
sudo apt install -y sbt

# -- PostgreSQL -- #
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable postgresql
sudo systemctl start postgresql

# -- SSH -- #
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# -- Firewall -- #
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'   # HTTP + HTTPS
sudo ufw allow 9000           # Play default dev port (remove if serving via nginx only)
sudo ufw --force enable

# -- VPN (WireGuard) -- #
sudo apt install -y wireguard
echo ""
echo "WireGuard installed. Run 'wg genkey' to generate your keypair and configure /etc/wireguard/wg0.conf"
echo "See: https://www.wireguard.com/quickstart/"

# -- UI Apps (optional) -- #
if [ "$UI_MODE" = true ]; then
  echo "Installing UI apps..."
  sudo snap install discord
  sudo snap install firefox
  sudo snap install sublime-text --classic
  sudo snap install vlc
  sudo snap install code --classic
else
  echo "Skipping UI apps (pass --ui to include them)"
fi

echo ""
echo "Setup complete!"
echo "Next steps:"
echo "  1. Configure WireGuard: /etc/wireguard/wg0.conf"
echo "  2. Set up port forwarding on your router for WireGuard (UDP 51820)"
echo "  3. Configure nginx reverse proxy for your Play app"
echo "  4. Open router port forwarding for SSH (TCP 22) or use WireGuard for SSH access"
echo "  5. Set up PostgreSQL user and database: sudo -u postgres psql"
echo "  6. Configure AWS credentials: aws configure"
