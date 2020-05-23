#!/usr/bin/env zsh

[ -f azure.tar ] && rm -f *.tar
docker build -t alexchiri/azure:latest .
docker save alexchiri/azure:latest -o azure.tar