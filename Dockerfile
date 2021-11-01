FROM ubuntu:bionic

ARG UTILS_USER_GID=1000
ARG UTILS_USER_UID=1000

RUN apt-get update \
  && apt-get install --no-install-recommends --yes --force-yes \
    locales \
    bind9-host \
    curl \
    dnsutils \
    httpie \
    iputils-ping \
    jq \
    netcat-openbsd \
    mongodb-clients \
    mysql-client \
    net-tools \
    postgresql-client \
    telnet \
    vim \
    nano \
    wget \
    python-setuptools \
    python-pip \
    openssh-client \
    p7zip-full \
  && rm -rf /var/lib/apt/lists/*

RUN pip -q install cqlsh

RUN apt-get install apt-transport-https ca-certificates dirmngr
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4
RUN echo "deb https://repo.clickhouse.com/deb/stable/ main/" | sudo tee \
    /etc/apt/sources.list.d/clickhouse.list
RUN apt-get update
RUN apt-get install -y clickhouse-server clickhouse-client

# Locale setup
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Unprivileged user setup
RUN groupadd --gid ${UTILS_USER_GID} utils \
  && useradd --uid ${UTILS_USER_UID} --gid ${UTILS_USER_GID} \
    --shell /bin/bash --create-home utils
USER utils
WORKDIR /home/utils

