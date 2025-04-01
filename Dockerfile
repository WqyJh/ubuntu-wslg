FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

RUN apt-get update && apt install -y software-properties-common && \
    add-apt-repository ppa:oibaf/graphics-drivers -y && \
    apt update && apt install -y vainfo mesa-va-drivers && \
    apt install -y openssh-server openssh-client wget vim chromium-browser && \
    userdel -r ubuntu && \
    useradd -ms /bin/bash wqy && \
    rm -rf /var/lib/apt/lists/*

RUN echo "wqy   ALL=(ALL)       ALL" >> /etc/sudoers

USER wqy

WORKDIR /home/wqy

RUN wget 'https://go.dev/dl/go1.23.7.linux-amd64.tar.gz' && \
    tar zvxf go1.23.7.linux-amd64.tar.gz && \
    rm -rf go1.23.7.linux-amd64.tar.gz && \
    echo "PATH=$HOME/go/bin:$PATH" >> ~/.bashrc
