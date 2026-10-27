#!/bin/bash

set -e

# Define variables
last9_username=${LAST9_USERNAME:-}
last9_password=${LAST9_PASSWORD:-}
last9_cluster_url=${LAST9_CLUSTER_URL:-}

# Verify Node Exporter is installed and running
echo "Verifying Node Exporter installation..."
if ! node_exporter --version &>/dev/null; then
    echo "Node Exporter is not installed or not working correctly. Please check the installation."
    exit 1
fi
echo "Node Exporter is verified."

# Check if necessary variables are set
if [ -z "$last9_username" ] || [ -z "$last9_password" ] || [ -z "$last9_cluster_url" ]; then
    echo "Error: Necessary variables (LAST9_USERNAME or LAST9_PASSWORD or LAST9_CLUSTER_URL) are not set."
    exit 1
fi

# Replace variables in docker-compose file
echo "Setting up Docker Compose configuration..."
sed -i "s/\${last9_username}/$last9_username/g" docker-compose.yaml
sed -i "s/\${last9_password}/$last9_password/g" docker-compose.yaml
sed -i "s/\${last9_cluster_url}/$last9_cluster_url/g" docker-compose.yaml

# Verify replacements
if grep -q '${last9_username}' docker-compose.yaml || grep -q '${last9_password}' docker-compose.yaml || grep -q '${last9_cluster_url}' docker-compose.yaml; then
    echo "Error: Failed to replace one or more variables in docker-compose.yaml."
    echo "Info: Manually replace the variables with actual values in docker-compose.yaml."
    exit 1
fi

# Run Docker Compose
echo "Running Docker Compose..."
docker-compose up -d
echo "Docker Compose is up and running."

