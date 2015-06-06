FROM ubuntu_base:15.04
MAINTAINER ml (metaml@gmail.com)

RUN DEBIAN_FRONTEND=noninteractive locale-gen en_US en_US.UTF-8
RUN DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales 
RUN DEBIAN_FRONTEND=noninteractive update-locale LC_ALL="en_US.UTF-8"

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:webupd8team/java
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && apt-get upgrade -y

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
    | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java8-installer
RUN DEBIAN_FRONTEND=noninteractive apt-get install oracle-java8-set-default
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget

ADD https://raw.github.com/jpetazzo/pipework/master/pipework /usr/local/bin/pipework
RUN chmod +x /usr/local/bin/pipework

ADD register /usr/local/bin/register
RUN chmod +x /usr/local/bin/register

ADD resolv.conf /etc/resolv.conf
RUN chmod +r /etc/resolv.conf

