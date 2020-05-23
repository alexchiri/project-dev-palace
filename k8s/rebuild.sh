#!/usr/bin/env zsh

[ -f k8s.tar ] && rm -f *.tar
docker build -t alexchiri/k8s:latest .
docker save alexchiri/k8s:latest -o k8s.tar