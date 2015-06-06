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

RUN apt-get install -y curl wget curl ruby maven
RUN apt-get install -y net-tools iputils-ping telnet netcat lsof less dnsutils

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz \
    | tar -xzf - -C /opt \
    && mv -f /opt/zookeeper-3.4.6 /opt/zookeeper \
    && chown -R daemon /opt/zookeeper

RUN mkdir -p /opt/exhibitor \
    && curl -Lo /opt/exhibitor/pom.xml https://raw.githubusercontent.com/Netflix/exhibitor/d911a16d704bbe790d84bbacc655ef050c1f5806/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml \
    && mvn -f /opt/exhibitor/pom.xml package \
    && ln -s /opt/exhibitor/target/exhibitor*jar /opt/exhibitor/exhibitor.jar

ADD start /opt/exhibitor/start
ADD web.xml /opt/exhibitor/web.xml

RUN mkdir -p /data /log && chown -R daemon /data /log

EXPOSE 2181 2888 3888

USER daemon
WORKDIR /opt/zookeeper
ENTRYPOINT ["/opt/exhibitor/start"]
