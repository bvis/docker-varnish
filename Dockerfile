FROM alpine:3.4

MAINTAINER Basilio Vera <basilio.vera@softonic.com>

ENV VARNISH_VERSION         4.1.2-r3

RUN apk add --update varnish=${VARNISH_VERSION}

ENV VCL_CONFIG="/etc/varnish/default.vcl" \
    CACHE_SIZE="64m" \
    VARNISHD_PARAMS="-p default_ttl=3600 -p default_grace=3600"

ADD rootfs /

EXPOSE 80

ENTRYPOINT ["/start.sh"]
