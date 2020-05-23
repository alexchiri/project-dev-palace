#!/usr/bin/env zsh

[ -f k8s-with-docker.tar ] && rm -f *.tar
docker build -t alexchiri/k8s-with-docker:latest .
docker save alexchiri/k8s-with-docker:latest -o k8s-with-docker.tar