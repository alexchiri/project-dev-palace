#!/usr/bin/env zsh

[ -f docker.tar ] && rm -f *.tar
docker build -t alexchiri/docker:latest .
docker container rm $(docker ps -a | grep "alexchiri/basic:latest" | awk '{ print $1 }')
docker run alexchiri/docker:latest
docker container export -o docker.tar $(docker ps -a | grep "alexchiri/docker:latest" | awk '{ print $1 }')