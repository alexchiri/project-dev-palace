#!/usr/bin/env zsh

[ -f learn.tar ] && rm -f *.tar
docker build -t alexchiri/learn:latest .
docker save alexchiri/learn:latest -o learn.tar