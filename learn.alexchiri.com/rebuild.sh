#!/usr/bin/env zsh

[ -f learn.tar ] && rm -f *.tar
docker build -t alexchiri/learn:latest .
docker container rm $(docker ps -a | grep "alexchiri/basic:latest" | awk '{ print $1 }')
docker run alexchiri/learn:latest
docker container export -o learn.tar $(docker ps -a | grep "alexchiri/learn:latest" | awk '{ print $1 }')