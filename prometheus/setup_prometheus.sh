#!/bin/bash

sudo apt-get update

echo "Installing Helm..."
# from https://helm.sh/docs/intro/install/ with apt
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
# Erreur non testée
if [ $? -ne 0]; then
    echo "Failed to install Helm"
    exit 1
fi
echo "OK"

echo "Installing Prometheus plugins..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
# Erreur non testée
if [ $? -ne 0]; then
    echo "Failed to install Prometheus plugins"
    exit 1
fi
echo "OK"


