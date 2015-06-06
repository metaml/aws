FROM ubuntu:15.04
MAINTAINER ml (metaml@gmail.com)

ENV DEBIAN_FRONTEND noninteractive  

RUN apt-get update -y && apt-get upgrade -y \
    && apt-get install -y --quiet unzip curl wget

RUN mkdir -p /opt/consul/bin
ADD https://dl.bintray.com/mitchellh/consul/0.5.2_linux_amd64.zip /tmp/consul.zip
RUN unzip /tmp/consul.zip -d /opt/consul/bin/ && chmod +x /opt/consul/bin/*
ADD https://dl.bintray.com/mitchellh/consul/0.5.2_web_ui.zip /tmp/webui.zip
RUN unzip /tmp/webui.zip -d /opt/consul && mv -f /opt/consul/dist /opt/consul/webui
RUN rm -rf /opt/consul/tmp

ADD start /opt/consul/start
RUN chmod a+x /opt/consul/start

# consul service ports:
# - server rpc: 8300
# - serf lan: 8301
# - serf wan: 8302
# - client rpc: 8400
# - http api: 8500 (wui)
# - dns: 8600
EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 8600 8600/udp

WORKDIR /opt/consul
USER root
ENTRYPOINT ["/opt/consul/start"]
