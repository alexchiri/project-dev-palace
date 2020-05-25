#!/usr/bin/env zsh

az acr repository delete -n alexchiri --repository basic
az acr repository delete -n alexchiri --repository k8s
az acr repository delete -n alexchiri --repository azure