FROM alexchiri/k8s:latest

USER root
RUN apt-get update && apt-get -y install libffi6 python3-pip

RUN python3 -m pip install azure-cli
