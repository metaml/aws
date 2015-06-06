# mesos-master
FROM ubuntu:15.04
MAINTAINER ml (metaml@gmail.com)

ENV DEBIAN_FRONTEND noninteractive  
ENV VERSION 0.22.1  

RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y
RUN apt-get install -y debconf \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
       | debconf-set-selections \
    && apt-get install --force-yes -y oracle-java8-installer \
    && apt-get install --force-yes -y oracle-java8-set-default
RUN apt-get install -y docker.io \
    && wget -q -O - http://mirror.cogentco.com/pub/apache/mesos/${VERSION}/mesos-${VERSION}.tar.gz \
       | tar -xzf - -C /opt \
    && mv -f /opt/mesos-${VERSION} /opt/mesos \
    && apt-get install -f -y \
    && rm -f mesos_${VERSION}-${PKG_RELEASE}.ubuntu1404_amd64.deb \
    && apt-get clean autoclean

RUN mkdir -p /data /log && chown -R daemon /data /log

EXPOSE 5050

USER daemon
WORKDIR /opt/mesos
CMD ["/opt/mesos/bin/mesos-master"]
