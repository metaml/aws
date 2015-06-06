FROM ubuntu:15.04
MAINTAINER ml (metaml@gmail.com)

ENV DEBIAN_FRONTEND noninteractive  
ENV VERSION 0.22.1  

RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:webupd8team/java
RUN apt-get update -y && apt-get upgrade -y

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true \
    | debconf-set-selections \
    && apt-get install --force-yes -y oracle-java8-installer \
    && apt-get install --force-yes -y oracle-java8-set-default
RUN apt-get install -y curl wget ruby
# for debugging
RUN apt-get install -y net-tools iputils-ping telnet netcat lsof less dnsutils

ADD pipework /usr/local/bin/pipework
RUN chmod a+x /usr/local/bin/pipework

ADD register /usr/local/bin/register
RUN chmod +x /usr/local/bin/register

ADD resolv.conf /etc/resolv.conf
RUN chmod +r /etc/resolv.conf

RUN mkdir -p /data /log && chown -R daemon /data /log

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    | tar -xzf - -C /opt \
    && mv -f /opt/zookeeper-3.4.6 /opt/zookeeper

ADD zoo.cfg /opt/zookeeper/conf/
ADD myid /opt/zookeeper/conf/
ADD start /opt/zookeeper/start

RUN chown -R daemon /opt/zookeeper

EXPOSE 2181 2888 3888

USER daemon
WORKDIR /opt/zookeeper
ENTRYPOINT ["/opt/zookeeper/start"]
