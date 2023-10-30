#!/bin/bash

# Define the path to your Zsh profile
zshrc_path="$HOME/.zshrc"
bashrc_path="$HOME/.bashrc"

echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$zshrc_path"
echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$bashrc_path"

export PATH="$HOME/.local/bin:$PATH"

# install odbc
# add path for the flows in the platform
pip install --user -r requirements.txt
pip install --user -r requirements-dev.txt

# install the pre-commit hooks
pre-commit autoupdate
pre-commit install

# install trivy
sudo apt update
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
