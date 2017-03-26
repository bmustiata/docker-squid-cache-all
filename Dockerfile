FROM sameersbn/squid:3.3.8-23
MAINTAINER Bogdan Mustiata <bogdan.mustiata@gmail.com>

RUN apt update -y && \
    apt install -y openssl && \
    mkdir /etc/squid3/ssl_cert && \
    cd /etc/squid3/ssl_cert && \
    openssl genrsa -des3 -passout pass:x -out myca.pass.key 2048 && \
    openssl rsa -passin pass:x -in myca.pass.key -out myca.key && \
    rm myca.pass.key && \
    openssl req -new -key myca.key -out myca.csr \
      -subj "/C=AT/ST=Wien/L=Wien/O=Germanium/OU=Germanium Infra/CN=get.germanium.com" && \
    openssl x509 -req -days 365 -in myca.csr -signkey myca.key -out myca.crt && \
    chown -R proxy:proxy /etc/squid3/ssl_cert

COPY etc/squid.conf /etc/squid3/squid.conf

