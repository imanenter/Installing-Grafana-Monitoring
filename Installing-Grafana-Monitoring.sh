#!/bin/bash

#******************************************************************#
# Title:Prometheus_Grafana_Monitoring.sh
# Description: Script to Installing Prometheus & Grafana Monitoring
# Author: Phoenix-999
# Link: github.com/Phoenix-999
# Date: January 27, 2024
#******************************************************************#


###############################
# Define ANSI color codes
###############################

GREEN='\033[1;32m'   # Bold green
NEON_GREEN='\033[1;38;5;154m'  # Neon green
BLUE='\033[1;34m'    # Bold blue
CYAN='\033[1;36m'    # Bold cyan
RED='\033[1;91m'     # Bold red
PURPLE='\033[1;35m'  # Bold purple
NC='\033[0m'         # No Color

# Function to print messages in green bold color
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# Function to print messages in red color
print_error() {
    echo -e "${RED}$1${NC}"
}

# Function to cleanup unnecessary files
cleanup() {
    rm -f prometheus-*.tar.gz node_exporter-*.tar.gz grafana-enterprise_*.deb
}

# Function to validate IP address format
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0  # Valid IP format
    else
        return 1  # Invalid IP format
    fi
}

# Get server IP address from user
read -p "$(echo -e "${NEON_GREEN}Enter your server IP address: ${NC}")" server_ip

# Validate IP address format
while ! validate_ip "$server_ip"; do
    print_error "Invalid IP address format. Please enter a valid IP address."
    read -p "$(echo -e "${NEON_GREEN}Enter your server IP address: ${NC}")" server_ip
done

# Display confirmation message
echo -e "$(echo -e "${CYAN}[✓] IP accepted!${NC}")"

###############################
# Step 1: Update and Upgrade System
###############################
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y build-essential
sudo apt install -y sudo wget

###############################
# Install Prometheus
###############################

# Get processor architecture
ARCH=$(uname -m)

# Set Prometheus version
PROMETHEUS_VERSION_AMD64="2.49.1"
PROMETHEUS_VERSION_ARM64="2.45.3"

# Set Prometheus file names
PROMETHEUS_FILE_AMD64="prometheus-${PROMETHEUS_VERSION_AMD64}.linux-amd64.tar.gz"
PROMETHEUS_FILE_ARM64="prometheus-${PROMETHEUS_VERSION_ARM64}.linux-arm64.tar.gz"

# Download and extract Prometheus based on architecture
if [ "$ARCH" == "x86_64" ]; then
    wget "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION_AMD64}/${PROMETHEUS_FILE_AMD64}"
    tar xzf "$PROMETHEUS_FILE_AMD64"
    PROMETHEUS_DIR="prometheus-${PROMETHEUS_VERSION_AMD64}.linux-amd64"
elif [ "$ARCH" == "aarch64" ]; then
    wget "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION_ARM64}/${PROMETHEUS_FILE_ARM64}"
    tar xzf "$PROMETHEUS_FILE_ARM64"
    PROMETHEUS_DIR="prometheus-${PROMETHEUS_VERSION_ARM64}.linux-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Move Prometheus directory
sudo mv "$PROMETHEUS_DIR" /etc/prometheus

# Create Prometheus systemd service file
cat <<EOL | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/etc/prometheus/prometheus --config.file=/etc/prometheus/prometheus.yml
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Reload, restart, enable, and check status of Prometheus
sudo systemctl daemon-reload
sudo systemctl restart prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus | grep "Active: active" | sed -e "s/Active: active/$(echo -e "${GREEN}Active: active${NC}")/" && print_success "$(echo -e "\e[1;33m[✓] Prometheus installed successfully\e[0m")"

# Allow port 9090
sudo ufw allow 9090/tcp


###############################
# Download Node Exporter
###############################

# Get processor architecture
ARCH=$(uname -m)

# Set Node Exporter version
NODE_EXPORTER_VERSION="1.7.0"

# Set Node Exporter file names
NODE_EXPORTER_FILE_AMD64="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64.tar.gz"
NODE_EXPORTER_FILE_ARM64="node_exporter-${NODE_EXPORTER_VERSION}.linux-arm64.tar.gz"

# Download and extract Node Exporter based on architecture
if [ "$ARCH" == "x86_64" ]; then
    wget "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_FILE_AMD64}"
    tar xzf "$NODE_EXPORTER_FILE_AMD64"
    NODE_EXPORTER_DIR="node_exporter-${NODE_EXPORTER_VERSION}.linux-amd64"
elif [ "$ARCH" == "aarch64" ]; then
    wget "https://github.com/prometheus/node_exporter/releases/download/v${NODE_EXPORTER_VERSION}/${NODE_EXPORTER_FILE_ARM64}"
    tar xzf "$NODE_EXPORTER_FILE_ARM64"
    NODE_EXPORTER_DIR="node_exporter-${NODE_EXPORTER_VERSION}.linux-arm64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Move Node Exporter directory
sudo mv "$NODE_EXPORTER_DIR" /etc/node_exporter

# Create Node Exporter systemd service file
cat <<EOL | sudo tee /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Reload, restart, enable, and check status of Node Exporter
sudo systemctl daemon-reload
sudo systemctl restart node_exporter
sudo systemctl enable node_exporter
sudo systemctl status node_exporter | grep "Active: active" | sed -e "s/Active: active/$(echo -e "${GREEN}Active: active${NC}")/" && print_success "$(echo -e "\e[1;33m[✓] Node Exporter installed successfully\e[0m")"

# Remove Existing Prometheus Configuration
sudo rm -f /etc/prometheus/prometheus.yml

# Create and Edit New Prometheus Configuration
cat <<EOL | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
- job_name: node
  static_configs:
  - targets: ['$server_ip:9100']
EOL

# Reload, restart, enable, and check status of Prometheus
sudo systemctl daemon-reload
sudo systemctl restart prometheus
sudo systemctl enable prometheus
sudo systemctl status prometheus | grep "Active: active" | sed -e "s/Active: active/$(echo -e "${GREEN}Active: active${NC}")/" && print_success "$(echo -e "\e[1;33m[✓] Prometheus configured successfully\e[0m")"

###############################
# Install Grafana
###############################

# Get processor architecture
ARCH=$(uname -m)

# Set Grafana version
GRAFANA_VERSION_AMD64="10.2.3"
GRAFANA_VERSION_ARM64="10.3.1"

# Install dependencies
sudo apt-get install -y adduser libfontconfig1 musl

# Set Grafana file names
GRAFANA_FILE_AMD64="grafana-enterprise_${GRAFANA_VERSION_AMD64}_amd64.deb"
GRAFANA_FILE_ARM64="grafana-enterprise_${GRAFANA_VERSION_ARM64}_arm64.deb"

# Function to wait for dpkg lock to be released
wait_for_dpkg_lock() {
    while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1 ; do
        echo "Waiting for dpkg lock to be released..."
        sleep 1
    done
}

# Wait for dpkg lock
wait_for_dpkg_lock

# Download and install Grafana based on architecture
if [ "$ARCH" == "x86_64" ]; then
    wget "http://167.235.206.142/down/${GRAFANA_FILE_AMD64}"
    sudo dpkg -i "$GRAFANA_FILE_AMD64"
elif [ "$ARCH" == "aarch64" ]; then
    wget "http://167.235.206.142/down/${GRAFANA_FILE_ARM64}"
    sudo dpkg -i "$GRAFANA_FILE_ARM64"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Restart, enable, and check status of Grafana
sudo systemctl restart grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server | grep "Active: active" | sed -e "s/Active: active/$(echo -e "${GREEN}Active: active${NC}")/" && print_success "$(echo -e "\e[1;33m[✓] Grafana installed successfully\e[0m")"

# Allow port 3000
sudo ufw allow 3000/tcp

###############################
# Optimizing Storage
###############################

# Deleting & Cleanup Unnecessary Files
cleanup && print_success "$(echo -e "\e[1;33m[✓] Cleanup completed successfully\e[0m")"


###############################
# Final message
###############################

echo -e "\n${BLUE}***********************************************************************************${NC}"
echo -e "${NEON_GREEN}Congratulations! All done.${NC}"
echo -e "${GREEN}Prometheus & Grafana Monitoring installed and configured successfully.${NC}"
echo -e "${PURPLE}Please configure the Grafana Dashboard by navigating to the web address below${NC}"
echo -e "${RED}http://$server_ip:3000/${NC}"
echo -e "${PURPLE}Please following the visual instructions on the GitHub page${NC}"
echo -e "${CYAN}https://github.com/Phoenix-999${NC}"
echo -e "${BLUE}***********************************************************************************${NC}"

###############################
# End of Script
###############################

# Disclaimer
# This script is offered without any warranty or guarantee, and it is provided as is. Use it at your own discretion and risk.
