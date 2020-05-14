#!/usr/bin/env zsh

[ -f basic.tar ] && rm -f *.tar
docker build --build-arg WSL_USER_PASS=$WSL_USER_PASS -t alexchiri/basic:latest .
docker container rm $(docker ps -a | grep "alexchiri/basic:latest" | awk '{ print $1 }')
docker run alexchiri/basic:latest
docker container export -o basic.tar $(docker ps -a | grep "alexchiri/basic:latest" | awk '{ print $1 }')