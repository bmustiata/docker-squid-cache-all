#!/bin/bash
set -e

create_log_dir() {
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

apply_backward_compatibility_fixes() {
  if [[ -f /etc/squid3/squid.user.conf ]]; then
    rm -rf /etc/squid3/squid.conf
    ln -sf /etc/squid3/squid.user.conf /etc/squid3/squid.conf
  fi
}

create_ssl_certificate_if_missing() {
  if [[ ! -f /etc/squid3/ssl_cert/myca.crt ]]; then
    echo "Generating /etc/squid3/ssl_cert/myca.crt signing certificate."
    cd /etc/squid3/ssl_cert
    openssl genrsa -des3 -passout pass:x -out myca.pass.key 2048
    openssl rsa -passin pass:x -in myca.pass.key -out myca.key
    rm myca.pass.key
    openssl req -new -key myca.key -out myca.csr \
      -subj "/C=AT/ST=Wien/L=Wien/O=Germanium/OU=Germanium Infra/CN=get.germanium.com"
    openssl x509 -req -days 365 -in myca.csr -signkey myca.key -out myca.crt
    chown -R proxy:proxy /etc/squid3/ssl_cert
  fi # [[ ! -f /etc/squid3/ssl_cert/myca.crt ]]
}


create_log_dir
create_cache_dir
apply_backward_compatibility_fixes
create_ssl_certificate_if_missing

# allow arguments to be passed to squid3
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid3 || ${1} == $(which squid3) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid3) -N -f /etc/squid3/squid.conf -z
  fi
  echo "Starting squid3..."
  exec $(which squid3) -f /etc/squid3/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
