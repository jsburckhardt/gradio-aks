#!/bin/bash


# Set variables
RESOURCE_GROUP="rsg-bunnings-swiftsolve-01"
LOCATION="australiaeast"
SERVICE_ACCOUNT_NAMESPACE="default"
SERVICE_ACCOUNT_NAME="gradio-aks-sa"
CLUSTER_NAME="aks-bunnings-swiftsolve-01"
ACR="amldsworkspaceacr"

# Create AKS cluster
az aks create -g "${RESOURCE_GROUP}" -n "${CLUSTER_NAME}" --node-count 1 --enable-oidc-issuer --enable-workload-identity --attach-acr "${ACR}" --enable-managed-identity || exit 1

# Get OIDC issuer URL
AKS_OIDC_ISSUER="$(az aks show -n "${CLUSTER_NAME}" -g "${RESOURCE_GROUP}" --query "oidcIssuerProfile.issuerUrl" -otsv)" || exit 1

# Create user-assigned identity
USER_ASSIGNED_IDENTITY_NAME="gradioaksidentity"
az identity create --name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP}" --location "${LOCATION}" || exit 1

# Assign role to user-assigned identity
RESOURCE_ID="$(az group show -g "${RESOURCE_GROUP}" --query "id" -o tsv)" || exit 1
az role assignment create --role "Cognitive Services User" --assignee "$(az identity show --resource-group "${RESOURCE_GROUP}" --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' -otsv)" --scope "${RESOURCE_ID}" || exit 1

# Retrieve aks credentials
az aks get-credentials -g "${RESOURCE_GROUP}" -n "${CLUSTER_NAME}" -a || exit 1

# Create Kubernetes service account
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
    annotations:
        azure.workload.identity/client-id: $(az identity show --resource-group "${RESOURCE_GROUP}" --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' -otsv)
    name: "${SERVICE_ACCOUNT_NAME}"
    namespace: "${SERVICE_ACCOUNT_NAMESPACE}"
EOF

# Federate the account and the managed identity
FEDERATED_IDENTITY_CREDENTIAL_NAME="gradioaksidentity-federated-credential"
az identity federated-credential create --name "${FEDERATED_IDENTITY_CREDENTIAL_NAME}" --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP}" --issuer "${AKS_OIDC_ISSUER}" --subject "system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}" || exit 1
