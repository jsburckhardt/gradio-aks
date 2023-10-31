#!/bin/bash

# Set variables
RESOURCE_GROUP="rsg-swiftsolve-01"
LOCATION="australiaeast"
OPENAI_NAME="aoai-swiftsolve-01"
GPT_35_TURBO="gpt-35-turbo"
GPT_4="gpt-4"

PROJECT_NAME="akstest"
END_DATE="20231115"
TEAM_NAME="THE TEAM"

# validate logged in into azure
echo "Validating Azure login..."
az account show || exit 1
echo "Azure login validated."

# Validate if resource group exists - otherwise create it with 3 tags (project, enddate, team) use variables
echo "Validating resource group..."
az group show -g "${RESOURCE_GROUP}" || az group create -g "${RESOURCE_GROUP}" -l "${LOCATION}" --tags project="${PROJECT_NAME}" enddate="${END_DATE}" team="${TEAM_NAME}" || exit 1
echo "Resource group validated."

# Create openai workspace if it doesn't exist
echo "Creating OpenAI workspace..."
az cognitiveservices account show -n $OPENAI_NAME -g $RESOURCE_GROUP || az cognitiveservices account create --name $OPENAI_NAME --resource-group $RESOURCE_GROUP --location $LOCATION --kind OpenAI --sku s0 --yes || exit 1
echo "OpenAI workspace created."

# Create a deployment GPT_35_TURBO and GPT_4
echo "Creating OpenAI deployments..."
# validate if deployment exits - otherwise create it
az cognitiveservices account deployment show --deployment-name $GPT_35_TURBO --name $OPENAI_NAME --resource-group $RESOURCE_GROUP || az cognitiveservices account deployment create --deployment-name $GPT_35_TURBO --model-format OpenAI --model-name $GPT_35_TURBO --model-version "0613" --name $OPENAI_NAME --resource-group $RESOURCE_GROUP || exit 1
az cognitiveservices account deployment show --deployment-name $GPT_4 --name $OPENAI_NAME --resource-group $RESOURCE_GROUP || az cognitiveservices account deployment create --deployment-name $GPT_4 --model-format OpenAI --model-name $GPT_4 --model-version "0613" --name $OPENAI_NAME --resource-group $RESOURCE_GROUP || exit 1
echo "OpenAI deployments created."
