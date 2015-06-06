FROM gliderlabs/registrator:latest
MAINTAINER ml (metaml@gmail.com)
ENV DEBIAN_FRONTEND noninteractive  

RUN mkdir -p /opt/registrator
ADD start /opt/registrator/start

WORKDIR /opt/registrator
USER root
ENTRYPOINT ["/opt/registrator/start"]
