#!/usr/bin/env zsh

[ -f basic.tar ] && rm -f *.tar
docker build --build-arg WSL_USER_PASS=$WSL_USER_PASS -t alexchiri/basic:latest .
docker save alexchiri/basic:latest -o basic.tar