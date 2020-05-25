# Project Dev Palace

## Flow with Azure and ACR Tasks

1. Create ACR called `alexchiri`
2. Create ACR tasks for each of the images
3. Update local development environments when the "chevron" is clicked in Windows Terminal. Replace default wsl command with a script that 
   1. pulls the latest image, 
   2. saves it as tar, 
   3. removes current WSL, (can I figure out somehow if there is a windows terminal running with that WSL?, otherwise I just create multiple profiles in WSL: simple ones and ones that update and they are just fake)
   4. imports the new one from the exported tar 

### 1. Create ACR called `alexchiri`

```bash
az acr create --name alexchiri \
              --resource-group alexchiri \
              --sku Basic
```

### 2. Create ACR tasks for each of the images


```bash
az acr task create \
    --registry $ACR_NAME \
    --name build-push-basic \
    --secret-arg WSL_USER_PASS=$WSL_USER_PASS \
    --image basic:latest \
    --context https://github.com/$GIT_USER/project-dev-palace.git#:basic \
    --file Dockerfile \
    --git-access-token $GIT_PAT

# run the build-push-basic task for the first time
az acr task run --registry $ACR_NAME --name build-push-basic

# check for logs and see if the task has run on code commit
az acr task logs --registry $ACR_NAME

az acr task create \
    --registry $ACR_NAME \
    --name build-push-k8s \
    --image k8s:latest \
    --arg REGISTRY_NAME=$ACR_NAME.azurecr.io \
    --context https://github.com/$GIT_USER/project-dev-palace.git#:k8s \
    --file Dockerfile \
    --git-access-token $GIT_PAT

az acr task run --registry $ACR_NAME --name build-push-k8s

az acr task create \
    --registry $ACR_NAME \
    --name build-push-azure \
    --image azure:latest \
    --arg REGISTRY_NAME=$ACR_NAME.azurecr.io \
    --context https://github.com/$GIT_USER/project-dev-palace.git#:azure \
    --file Dockerfile \
    --git-access-token $GIT_PAT

az acr task run --registry $ACR_NAME --name build-push-azure
```

## Submodule related

```bash
git submodule add --name azure https://github.com/alexchiri/project-dev-palace-azure azure
git submodule add --name basic https://github.com/alexchiri/project-dev-palace-basic basic
git submodule add --name docker https://github.com/alexchiri/project-dev-palace-docker docker
git submodule add --name k8s https://github.com/alexchiri/project-dev-palace-k8s k8s
git submodule add --name k8s-with-docker https://github.com/alexchiri/project-dev-palace-k8s-with-docker k8s-with-docker
git submodule add --name learn.alexchiri.com https://github.com/alexchiri/project-dev-palace-learn.alexchiri.com learn.alexchiri.com



git config --global diff.submodule log
```

## Obsolete

Create an Azure Principal to be able to login:

```bash
az ad sp create-for-rbac --name UploadImagesToContainer
```

Delete an Azure Principal:

```bash
az ad sp delete --id
```