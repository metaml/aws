FROM ubuntu:15.04
MAINTAINER M. Lee (michael@sendence.com)

env DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --quiet dnsmasq wget curl ruby net-tools iputils-ping

#ADD resolv.conf /etc/resolv.conf
#RUN chmod +r /etc/resolv.conf

WORKDIR /tftp
ENV ARCH amd64
ENV DIST trusty
ENV MIRROR http://archive.ubuntu.com
RUN wget $MIRROR/ubuntu/dists/$DIST/main/installer-$ARCH/current/images/netboot/ubuntu-installer/$ARCH/linux
RUN wget $MIRROR/ubuntu/dists/$DIST/main/installer-$ARCH/current/images/netboot/ubuntu-installer/$ARCH/initrd.gz
RUN wget $MIRROR/ubuntu/dists/$DIST/main/installer-$ARCH/current/images/netboot/ubuntu-installer/$ARCH/pxelinux.0
RUN mkdir pxelinux.cfg
RUN printf "DEFAULT linux\nKERNEL linux\nAPPEND initrd=initrd.gz\n" > pxelinux.cfg/default

ADD start /opt/ddt/start
RUN chmod +x /opt/ddt/start

RUN mkdir -p /var/lib/misc && chown daemon /var/lib/misc

EXPOSE 53 53/udp 67 67/udp 
WORKDIR /opt/ddt
USER root
ENTRYPOINT ["/opt/ddt/start"]
