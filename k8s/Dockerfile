FROM alexchiri/basic:latest

USER root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get -y install jq unzip python3 apt-transport-https ca-certificates software-properties-common jid pkg-config

USER alex

ENV KUBECTL_VERSION="v1.18.2"
ENV HELM_VERSION="v3.2.1"
ENV HELMSMAN_VERSION="3.3.0"
ENV GO_VERSION="1.14.2"
ENV GO111MODULE="on"
ENV KIND_VERSION="v0.8.0"

SHELL ["zsh", "-c"]

# install go
RUN cd /tmp && curl -LO "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz" \
  && sudo tar -xvzf "./go${GO_VERSION}.linux-amd64.tar.gz" -C /usr/local \
  && echo "export PATH=\$PATH:/usr/local/go/bin" >> /home/alex/.zshrc

# install kind
RUN /usr/local/go/bin/go get "sigs.k8s.io/kind@${KIND_VERSION}"
RUN sed -i 's~PATH:~PATH:/home/alex/go/bin:~g' ~/.zshrc

# install kubectl
RUN cd /tmp && curl -LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && sudo mv ./kubectl /usr/local/bin/kubectl

# install helm
RUN cd /tmp && curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -xzvf ./helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && chmod +x ./linux-amd64/helm \
    && sudo mv ./linux-amd64/helm /usr/local/bin/helm

# install helmdiff
RUN helm plugin install https://github.com/databus23/helm-diff --version master

# install helmsman
RUN cd /tmp && curl -LO "https://github.com/Praqma/helmsman/releases/download/v${HELMSMAN_VERSION}/helmsman_${HELMSMAN_VERSION}_linux_amd64.tar.gz" \
  && tar -xzvf "./helmsman_${HELMSMAN_VERSION}_linux_amd64.tar.gz" \
  && chmod +x ./helmsman \
  && sudo mv ./helmsman /usr/local/bin/helmsman

# install kubens and kubectx
RUN sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
RUN sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
RUN sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
RUN mkdir -p ~/.oh-my-zsh/completions
RUN chmod -R 755 ~/.oh-my-zsh/completions
RUN sudo ln -s /opt/kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
RUN sudo ln -s /opt/kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh

# add kubectl autocomplete with alias
RUN echo "source <(kubectl completion zsh)" >> ~/.zshrc
RUN echo "alias k=kubectl" >> ~/.zshrc
RUN echo "complete -F __start_kubectl k" >> ~/.zshrc