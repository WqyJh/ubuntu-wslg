FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

# Uncomment the lines below to use a 3rd party repository
# to get the latest (unstable from mesa/main) mesa library version
RUN apt-get update && apt install -y software-properties-common
RUN add-apt-repository ppa:oibaf/graphics-drivers -y

RUN apt update && apt install -y vainfo mesa-va-drivers

ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

RUN apt install -y openssh-server openssh-client wget vim chromium-browser

USER ubuntu

WORKDIR /home/ubuntu

RUN wget 'https://go.dev/dl/go1.23.7.linux-amd64.tar.gz' && \
    tar zvxf go1.23.7.linux-amd64.tar.gz && \
    mv go /home/ubuntu/go && \
    echo "PATH=$HOME/go/bin:$PATH" >> ~/.bashrc && \
