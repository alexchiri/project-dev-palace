#!/usr/bin/env zsh

[ -f azure.tar ] && rm -f *.tar
docker build -t alexchiri/azure:latest .
docker container rm $(docker ps -a | grep "alexchiri/azure:latest" | awk '{ print $1 }')
docker container export -o azure.tar $(docker create alexchiri/azure:latest)