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
