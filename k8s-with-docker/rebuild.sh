#!/usr/bin/env zsh

[ -f k8s-with-docker.tar ] && rm -f *.tar
docker build -t alexchiri/k8s-with-docker:latest .
docker container rm $(docker ps -a | grep "alexchiri/basic:latest" | awk '{ print $1 }')
docker run alexchiri/k8s-with-docker:latest
docker container export -o k8s-with-docker.tar $(docker ps -a | grep "alexchiri/k8s-with-docker:latest" | awk '{ print $1 }')