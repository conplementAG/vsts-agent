FROM ubuntu:22.04 as ubuntu-base

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes


#RUN sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get -y update
RUN apt-get install -y curl

# Trusty needs an updated backport of apt to avoid hash sum mismatch errors
RUN [ "xenial" = "trusty" ] \
 && curl -s https://packagecloud.io/install/repositories/computology/apt-backport/script.deb.sh |  bash \
 && apt-get update \
 && apt-get install apt \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /etc/apt/sources.list.d/* \
 || echo -n

RUN apt-get -y update 
RUN apt-get install -y --no-install-recommends 
RUN apt-get install ca-certificates 
RUN apt-get install gpg 
RUN apt-get install jq 
RUN apt-get install git 
RUN apt-get install gnupg 
		
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update 
RUN apt-get install nodejs -y

RUN apt-get install iputils-ping \
        libcurl4 \
        libunwind8 \
        netcat

RUN apt install build-essential checkinstall zlib1g-dev -y

RUN apt-get -y update 

RUN apt-get install openjdk-18-jre
RUN apt-get install openjdk-18-jdk

RUN npm install --global yarn
RUN npm install --global lerna

ARG yarn=yarn
ARG lerna=lerna

RUN apt-get install nodejs -y
RUN apt-get install wget

WORKDIR /vsts

COPY ./dotnet-install.sh .
RUN chmod +x dotnet-install.sh
RUN ./dotnet-install.sh --channel 2.0
RUN ./dotnet-install.sh --channel 2.1
RUN ./dotnet-install.sh --channel 2.2
RUN ./dotnet-install.sh --channel 3.0
RUN ./dotnet-install.sh --channel 3.1
RUN ./dotnet-install.sh --channel 5.0

RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

   
RUN apt update -y
RUN apt upgrade -y
RUN apt-get update
RUN apt-get install -y dotnet-host
RUN apt-get install -y dotnet-sdk-6.0
RUN apt-get install -y dotnet-sdk-8.0

ARG dotnet8=dotnet8

WORKDIR /usr/src/
RUN apt install make libssl-dev libghc-zlib-dev libcurl4-gnutls-dev libexpat1-dev gettext unzip
RUN wget https://github.com/git/git/archive/v2.44.0.tar.gz --no-check-certificate -O git.tar.gz 
RUN tar -xf git.tar.gz

WORKDIR /usr/src/git-2.44.0
RUN make prefix=/usr/local all
RUN make prefix=/usr/local install

RUN export PATH=$PATH:/usr/src/git-2.44.0

# Accept the TEE EULA
RUN mkdir -p "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && cd "/root/.microsoft/Team Foundation/4.0/Configuration/TEE-Mementos" \
 && echo '<ProductIdData><eula-14.0 value="true"/></ProductIdData>' > "com.microsoft.tfs.client.productid.xml"


COPY ./start.sh .
RUN chmod +x start.sh

CMD ["./start.sh"]

FROM ubuntu-base

ENV DOCKER_CHANNEL stable
ENV DOCKER_VERSION 25.0.3

RUN set -ex \
 && curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/`uname -m`/docker-${DOCKER_VERSION}.tgz" -o docker.tgz \
 && tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin \
 && rm docker.tgz \
 && docker -v

ENV DOCKER_COMPOSE_VERSION v2.24.6

RUN set -x \
 && curl -fSL "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m`" -o /usr/local/bin/docker-compose \
 && chmod +x /usr/local/bin/docker-compose \
 && docker-compose -v
