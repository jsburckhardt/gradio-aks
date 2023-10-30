# gradio-aks

`gradio-aks` is a repository designed to demonstrate how to utilize Azure OpenAI with AD credentials. This guide encompasses creating a Docker container and subsequently deploying it into Azure Kubernetes Service (AKS).

## Azure Credentials

For a detailed walkthrough on Azure Managed Identities with Workload Identity Federation, refer to the following resources:

- [Azure Managed Identities with Workload Identity Federation | Identity in the cloud](https://blog.identitydigest.com/azuread-federate-mi/)

- [Tutorial - Use a workload identity with an application on Azure Kubernetes Service (AKS) - Azure Kubernetes Service | Microsoft Learn](https://learn.microsoft.com/en-us/azure/aks/learn/tutorial-kubernetes-workload-identity)

- [How to configure Azure OpenAI Service with managed identities - Azure OpenAI | Microsoft Learn](https://learn.microsoft.com/en-us/azure/ai-services/openai/how-to/managed-identity)

## Features

- Run the application locally in the devcontainer
- Creation of Docker containers tailored for Azure OpenAI with AD credentials.
- Assistance in deploying the Docker container to AKS.

## Pre-requisites

- resource group with Azure OpenAI
- Azure OpeanAI deployments (depends the deployement you want to use): `gpt-35-turbo`, `gpt-4`

## Running the Application Locally

- Remember that we are using Azure.Credentials for connecting with Azure OpenAI. That means unless you have the required permissions to talk with OpenAI it won't work till you obtain them.
- Let's use az cli. Login first:

```bash
az login
```

- Assign the role to yourself

```bash
export RG=<rg with ai resource>
export user=$(az ad signed-in-user show --query "userPrincipalName" -o tsv)
export resourceId=$(az group show -g $RG --query "id" -o tsv)
az role assignment create --role "Cognitive Services User" --assignee $user --scope $resourceId
```

- run the application

```bash
make gradio
```

## AKS Creation and Configuration

- To create and configurate the cluster follow: [infra](./infra/azcli.sh)
- To release the application build it and then update the container in (or use mine): [manifest](./release/manifest.yaml)

---

## Contribute

Please submit issues and pull requests for any bugs you find or enhancements you propose.

---



## Before running it locally



pushing

docker login ghcr.io/$(USER)

validate your package is public or you'll need to configure docker pull secret in your aks {link}
