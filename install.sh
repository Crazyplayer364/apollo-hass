#!/bin/bash

# Update package index
echo "Updating package index..."
sudo apt update

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
echo "Adding Docker's GPG key..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding Docker repository
echo "Updating package index..."
sudo apt update

# Install Docker and Docker Compose
echo "Installing Docker and Docker Compose..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose

# Enable and start Docker service
echo "Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version
docker-compose --version

# Create homeassistant directory in the user's home if it doesn't already exist
echo "Creating homeassistant directory..."
mkdir -p ~/homeassistant/

# Create docker-compose.yaml file with specified content
echo "Creating docker-compose.yaml file..."
cat <<EOL > docker-compose.yaml
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - ~/homeassistant/config:/config
      - /etc/localtime:/etc/localtime:ro
      - /run/dbus:/run/dbus:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
EOL

echo "docker-compose.yaml has been created successfully!"
echo "Docker and Docker Compose have been installed, and the docker-compose.yaml file is ready."

echo "Running Home Assistant Installation via Docker Compose"

# Installing Docker Compose
sudo docker-compose up -d

# Display access instructions
echo "=================================================="
echo "Home Assistant Installation Complete!"
echo
echo "To access Home Assistant, open your web browser and go to:"
echo
echo "    http://<YOUR_DEVICE_IP>:8123"
echo
echo "Replace <YOUR_DEVICE_IP> with the actual IP address of this device."
echo "To find the IP address, run: ip a"
echo "=================================================="
