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

wget https://github.com/prometheus/prometheus/releases/download/v2.45.3/prometheus-2.45.3.linux-arm64.tar.gz
tar xzf prometheus-2.45.3.linux-arm64.tar.gz
sudo mv prometheus-2.45.3.linux-arm64 /etc/prometheus

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

wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-arm64.tar.gz
tar xzf node_exporter-1.7.0.linux-arm64.tar.gz
sudo mv node_exporter-1.7.0.linux-arm64 /etc/node_exporter

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

sudo apt-get install -y adduser libfontconfig1 musl
wget https://dl.grafana.com/enterprise/release/grafana-enterprise_10.3.1_arm64.deb
sudo dpkg -i grafana-enterprise_10.3.1_arm64.deb

# Restart, enable, and check status of Grafana
sudo systemctl restart grafana-server
sudo systemctl enable grafana-server
sudo systemctl status grafana-server | grep "Active: active" | sed -e "s/Active: active/$(echo -e "${GREEN}Active: active${NC}")/" && print_success "$(echo -e "\e[1;33m[✓] Grafana installed successfully\e[0m")"


# Allow port 3000
sudo ufw allow 3000/tcp

# Cleanup unnecessary files
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
