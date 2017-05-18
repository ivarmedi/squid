FROM debian:jessie
MAINTAINER Ivar Larsson <ivar@larsson.me>

ENV squid_major 3
ENV squid_minor 5
ENV squid_patch 25

RUN apt-get -y update && apt-get -y --no-install-recommends install curl build-essential libssl-dev ca-certificates \
    && cd /tmp \
    && curl -osquid.tar.gz http://www.squid-cache.org/Versions/v${squid_major}/${squid_major}.${squid_minor}/squid-${squid_major}.${squid_minor}.${squid_patch}.tar.gz \
    && tar -zxvf squid.tar.gz \
    && cd squid-${squid_major}.${squid_minor}.${squid_patch} \
    && ./configure --prefix=/usr --exec-prefix=/usr --includedir=/usr/include --datadir=/usr/share --libdir=/usr/lib64 --libexecdir=/usr/lib64/squid --localstatedir=/var \
      --sysconfdir=/etc/squid --sharedstatedir=/var/lib --with-logdir=/var/log/squid --with-pidfile=/var/run/squid.pid --with-default-user=squid --enable-silent-rules \
      --enable-dependency-tracking -with-openssl --enable-icmp --enable-delay-pools --enable-useragent-log --enable-esi --enable-follow-x-forwarded-for --enable-auth \
    && make && make install \
    && useradd -M -s /bin/false squid && chown -R squid.squid /var/log/squid /var/cache/squid \
    && rm -rf /var/lib/apt/lists/* /tmp/squid*

COPY etc/ /etc

ENTRYPOINT /usr/sbin/squid -N
