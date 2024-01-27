#!/bin/bash


###############################
# Define ANSI color codes
###############################

RED='\033[1;91m'     # Bold red
GREEN='\033[1;32m'   # Bold green
YELLOW='\033[1;33m'  # Bold yellow
CYAN='\033[1;36m'    # Bold cyan
NC='\033[0m'         # No Color

# Function to display an error message
function display_error {
    echo -e "${RED}\033[1mInvalid response. Please type 'YES' or 'NO' to confirm or cancel the deletion.${NC}"
}

# Confirmation prompt with three attempts
for attempt in {1..3}; do
    echo -e "${YELLOW}\033[1mYou are initiating the deletion of the Grafana Monitoring package.${NC}"
    echo -e "${YELLOW}\033[1mAre you sure you would like to proceed with the deletion?${NC}"
    echo -e "${YELLOW}\033[1mTo cancel the deletion, type${NC} ${RED}\033[1m'NO'${NC}${YELLOW}\033[1m and to confirm deletion, type ${NC}${RED}\033[1m'YES'${NC}"
    read -p "$(echo -e "${RED}\033[1mPlease confirm your answer:${NC} ")" answer

    # Convert the user's response to uppercase for case-insensitive comparison
    answer_uppercase=$(echo "$answer" | tr '[:lower:]' '[:upper:]')

    # Check user's response
    if [[ "$answer_uppercase" == "YES" ]]; then
        echo "Proceeding with the deletion..."
        break
    elif [[ "$answer_uppercase" == "NO" ]]; then
        echo "Cleanup aborted. No changes were made."
        exit 0
    else
        display_error
        if [ $attempt -eq 3 ]; then
            echo -e "${RED}\033[1mToo many incorrect attempts. Exiting.${NC}"
            exit 1
        fi
    fi
done


###############################
# Stop and disable services
###############################

sudo systemctl stop prometheus
sudo systemctl disable prometheus
sudo systemctl stop node_exporter
sudo systemctl disable node_exporter
sudo systemctl stop grafana-server
sudo systemctl disable grafana-server

###############################
# Remove installed packages
###############################

sudo apt-get remove --purge prometheus node_exporter grafana-enterprise -y

# Remove configuration files and directories
sudo rm -rf /etc/prometheus /etc/node_exporter /etc/systemd/system/prometheus.service /etc/systemd/system/node_exporter.service
sudo rm -f /etc/prometheus/prometheus.yml
sudo rm -f /usr/sbin/grafana-server
sudo rm -f /etc/apt/sources.list.d/grafana.list

# Remove the script file
sudo rm -f /Installing-Grafana-Monitoring.sh

# Remove unnecessary files
cleanup

###############################
# Reload systemd
###############################

sudo systemctl daemon-reload

###############################
# Remove firewall rules
###############################

sudo ufw delete allow 9090/tcp
sudo ufw delete allow 3000/tcp

###############################
# Final message
###############################

echo -e "\n${RED}***********************************************************************************${NC}"
echo -e "${GREEN}\033[1mDeletion successfully completed.${NC}"
echo -e "${CYAN}\033[1mAll components and files related to Grafana Monitoring have been removed.${NC}"
echo -e "${RED}***********************************************************************************${NC}"

###############################
# End of Script
###############################
