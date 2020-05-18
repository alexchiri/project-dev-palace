#!/usr/bin/env zsh

[ -f learn.tar ] && rm -f *.tar
docker build -t alexchiri/learn:latest .
docker container rm $(docker ps -a | grep "alexchiri/basic:latest" | awk '{ print $1 }')
docker container export -o learn.tar $(docker create alexchiri/learn:latest)