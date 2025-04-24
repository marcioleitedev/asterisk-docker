FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y build-essential wget curl gnupg2 uuid-dev libjansson-dev libxml2-dev libsqlite3-dev \
    libssl-dev libedit-dev net-tools vim iputils-ping libncurses5-dev libnewt-dev \
    libcurl4-openssl-dev libspeexdsp-dev libopus-dev

# Baixando e instalando o Asterisk
RUN cd /usr/src && \
    wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-20-current.tar.gz && \
    tar xvfz asterisk-20-current.tar.gz && \
    cd asterisk-20.* && \
    contrib/scripts/install_prereq install && \
    ./configure && \
    make menuselect.makeopts && \
    make -j2 && \
    make install && \
    make samples && \
    make config

# Copiando configurações personalizadas
COPY configs/* /etc/asterisk/

EXPOSE  8088/tcp

CMD ["/usr/sbin/asterisk", "-f", "-vvv"]
