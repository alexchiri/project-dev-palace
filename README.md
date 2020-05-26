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

Had to split everything in submodules because tasks get triggered by every commit being done on a repo, so if you have all Dockerfiles in the same repo, for each commit you make, all images will be rebuilt at least once. That's fine in the end if you are not in a hurry, but it can get quite expensive because there are a lot of un-necessary task runs. You also avoid triggering builds for changes to README docs or files not related to the actual Docker images.

So every Docker image is in its own repo and the parent repo uses all submodules with Docker images.

With the tasks below, when a base image gets changed, this will trigger a build for the base image and all the images depending on the base image and all the images depending on them and so on, which is very neat.

I am using latest for all images, since I am not making any use of versioning at this point, but there comes a point when it is important to know which version of the dev environment you are running, but I will take that when I get there.

```bash
az acr task create \
    --registry $ACR_NAME \
    --name build-push-basic \
    --secret-arg WSL_USER_PASS=$WSL_USER_PASS \
    --image basic:latest \
    --context https://github.com/$GIT_USER/project-dev-palace-basic.git \
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
    --context https://github.com/$GIT_USER/project-dev-palace-k8s.git \
    --file Dockerfile \
    --git-access-token $GIT_PAT

az acr task run --registry $ACR_NAME --name build-push-k8s

az acr task create \
    --registry $ACR_NAME \
    --name build-push-azure \
    --image azure:latest \
    --arg REGISTRY_NAME=$ACR_NAME.azurecr.io \
    --context https://github.com/$GIT_USER/project-dev-palace-azure.git \
    --file Dockerfile \
    --git-access-token $GIT_PAT

az acr task run --registry $ACR_NAME --name build-push-azure
```

## 3 Update local development environments

Use `update_wsl.py` script in the `commandLine` property of the Windows Terminal profile and provide the parameters required by the script:

```bash
cmd.exe /C az acr login -n alexchiri && cd %userprofile% && python C:\\Users\\alex\\Projects\\project-dev-palace\\update_wsl.py alexchiri basic basic D:\\WSLs
```

This execution is rather slow and the Python script is rather basic, but it works. 
Ideally, I would be able to determine if there is a process using a WSL distro and in that case, skip the update. But since I worked-around that for now by creating a new profile in Windows Terminal that maps to an existing WSL distro and that runs the update script. So it is a manual action and you know that if you have the WSL that you are updating opened, that session will be closed.


## Submodule related

```bash
git submodule add --name azure https://github.com/alexchiri/project-dev-palace-azure azure
git submodule add --name basic https://github.com/alexchiri/project-dev-palace-basic basic
git submodule add --name docker https://github.com/alexchiri/project-dev-palace-docker docker
git submodule add --name k8s https://github.com/alexchiri/project-dev-palace-k8s k8s
git submodule add --name k8s-with-docker https://github.com/alexchiri/project-dev-palace-k8s-with-docker k8s-with-docker
git submodule add --name learn.alexchiri.com https://github.com/alexchiri/project-dev-palace-learn.alexchiri.com learn.alexchiri.com



git config --global diff.submodule log
git config status.submodulesummary 1
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