FROM ubuntu:18.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get -y install zsh curl git sudo locales vim dos2unix wget iputils-ping iproute2

# disable annoying warning introduced in sudo: https://github.com/sudo-project/sudo/issues/42
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

# create user and set password
ARG WSL_USER_PASS
RUN useradd --create-home alex
RUN echo "${WSL_USER_PASS}\n${WSL_USER_PASS}" | passwd alex
RUN usermod -aG sudo alex

COPY wsl.conf /etc/wsl.conf

# include script to bring ssh files (and make sure it has linux style line endings)
COPY bring_ssh_files_from_windows /usr/local/bin/bring_ssh_files_from_windows
RUN chmod +x /usr/local/bin/bring_ssh_files_from_windows
RUN dos2unix /usr/local/bin/bring_ssh_files_from_windows

# generate locale so the agnoster zsh theme works
RUN locale-gen en_US.UTF-8

USER alex

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# configure git
RUN git config --global user.email "alex@alexchiri.com"
RUN git config --global user.name "Alexandru Chiritescu"
RUN git config --global core.autocrlf false

# change the shade of blue in the theme
RUN sed -i '0,/blue/{s/blue/39d/}' /home/alex/.oh-my-zsh/themes/agnoster.zsh-theme

USER root
# copy zsh config
COPY .zshrc /home/alex/.zshrc
RUN chown alex:alex /home/alex/.zshrc
RUN usermod --shell /usr/bin/zsh alex

# copy vim config
COPY .vimrc /home/alex/.vimrc
RUN dos2unix /home/alex/.vimrc
RUN chown alex:alex /home/alex/.vimrc