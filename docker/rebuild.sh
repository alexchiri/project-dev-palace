#!/usr/bin/env zsh

[ -f docker.tar ] && rm -f *.tar
docker build -t alexchiri/docker:latest .
docker save alexchiri/docker:latest -o docker.tar