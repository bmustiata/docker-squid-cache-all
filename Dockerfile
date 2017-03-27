FROM sameersbn/squid:3.3.8-23
MAINTAINER Bogdan Mustiata <bogdan.mustiata@gmail.com>

COPY etc/squid.conf /etc/squid3/squid.conf
COPY entrypoint.sh /sbin/entrypoint.sh

RUN chmod 755 /sbin/entrypoint.sh && \
    apt update -y && \
    apt install -y openssl && \
    mkdir /etc/squid3/ssl_cert

VOLUME /etc/squid3/ssl_cert

