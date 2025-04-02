FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ENV LIBVA_DRIVER_NAME=d3d12
ENV LD_LIBRARY_PATH=/usr/lib/wsl/lib

RUN printf '#!/bin/sh\n\
\n\
# Clear existing host keys and generate new ones.\n\
rm -f /etc/ssh/ssh_host_*_key &&\n\
ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -P "" &&\n\
ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -P "" &&\n\
ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -P "" &&\n\
ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -P "" \n\
\n\
printf "#!/bin/sh\n\nexec /usr/sbin/sshd -D\n" > /entry-point.sh\n\
exec /usr/sbin/sshd -D\n' \
> /entry-point.sh && \
    apt-get update && apt install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:oibaf/graphics-drivers -y && \
    apt update && apt install -y --no-install-recommends vainfo mesa-va-drivers && \
    apt install -y --no-install-recommends sudo openssh-server openssh-client wget vim chromium-browser && \
    userdel -r ubuntu && \
    useradd -ms /bin/bash wqy && \
    mkdir -p /var/run/sshd && \
    echo "wqy   ALL=(ALL)       ALL" >> /etc/sudoers && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 22

CMD ["/entry-point.sh"]

USER wqy

WORKDIR /home/wqy

RUN wget 'https://go.dev/dl/go1.23.7.linux-amd64.tar.gz' && \
    tar zvxf go1.23.7.linux-amd64.tar.gz && \
    rm -rf go1.23.7.linux-amd64.tar.gz && \
    echo "PATH=$HOME/go/bin:$PATH" >> ~/.bashrc
