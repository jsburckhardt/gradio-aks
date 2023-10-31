#!/bin/bash

set -euo pipefail

echo "Validating environment variables"

if [[ -z "${REGISTRY}" ]]; then
    echo "REGISTRY environment variable is not set"
    exit 1
fi
echo "REGISTRY: $REGISTRY"

if [[ -z "${REPO_NAME}" ]]; then
    echo "REPO_NAME environment variable is not set"
    exit 1
fi
echo "REPO_NAME: $REPO_NAME"

if [[ -z "${APP_VERSION}" ]]; then
    echo "APP_VERSION environment variable is not set"
    exit 1
fi
echo "APP_VERSION: $APP_VERSION"

echo "Validating tools"

if ! command -v trivy &> /dev/null
then
    echo "trivy could not be found, installing..."
    sudo apt update
    sudo apt-get install wget apt-transport-https gnupg lsb-release -y
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
    sudo apt-get update
    sudo apt-get install trivy
fi

echo "Setting up environment"

IMAGE=$REGISTRY/$REPO_NAME/chatbot:$APP_VERSION
IMAGE_LATEST=$REGISTRY/$REPO_NAME/chatbot:latest
echo "IMAGE: $IMAGE"

echo "Building and pushing image"
docker build -t "$IMAGE" -f Dockerfile ..
docker tag "$IMAGE" "$IMAGE_LATEST"
docker push "$IMAGE"
docker push "$IMAGE_LATEST"

echo "Generating sbom attestating and signing image"
trivy image --format spdx-json -o sbom.spdx.json "$IMAGE"
