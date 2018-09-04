FROM debian:jessie

MAINTAINER Basilio Vera <basilio.vera@softonic.com>

ARG version="0.1.0-dev"
ARG build_date="unknown"
ARG commit_hash="unknown"
ARG vcs_url="unknown"
ARG vcs_branch="unknown"

LABEL org.label-schema.vendor="Softonic" \
    org.label-schema.name="Varnish" \
    org.label-schema.description="Varnish daemon based on Alpine" \
    org.label-schema.usage="/src/README.md" \
    org.label-schema.url="https://github.com/bvis/docker-varnish/blob/master/README.md" \
    org.label-schema.vcs-url=$vcs_url \
    org.label-schema.vcs-branch=$vcs_branch \
    org.label-schema.vcs-ref=$commit_hash \
    org.label-schema.version=$version \
    org.label-schema.schema-version="1.0" \
    org.label-schema.docker.cmd.devel="" \
    org.label-schema.docker.params="VARNISH_DEBUG_SECRET=Change the default debug password,\
CACHE_SIZE=Determines the cache size used by varnish,\
VARNISHD_PARAMS=Other parameters you want to pass to the varnish daemon" \
    org.label-schema.build-date=$build_date

ENV VARNISH_VERSION="4.1.10-1~jessie" \
    VCL_CONFIG="/etc/varnish/default.vcl" \
    CACHE_SIZE="64m" \
    VARNISHD_PARAMS="-p default_ttl=3600 -p default_grace=3600 -n /varnishfs"

RUN apt-get update && apt-get install -y debian-archive-keyring && apt-get install -y curl gnupg apt-transport-https
COPY rootfs/etc/apt/sources.list.d/varnishcache_varnish41.list /etc/apt/sources.list.d/varnishcache_varnish41.list
RUN curl -L https://packagecloud.io/varnishcache/varnish41/gpgkey | apt-key add - \
 && apt-get update && apt-get install -y git build-essential automake libtool varnish=$VARNISH_VERSION varnish-dev varnish-agent python-docutils \
 && git clone https://github.com/varnish/varnish-modules /varnish-modules \
 && cd /varnish-modules \
 && ./bootstrap && ./configure \
 && make \
 && make install \
 && cd / && rm -rf /varnish-modules && rm -rf /var/lib/apt/lists/*

COPY rootfs /

EXPOSE 80

ENTRYPOINT ["/start.sh"]

CMD ["varnishd"]
