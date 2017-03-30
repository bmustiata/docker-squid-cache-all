docker kill squid-proxy
docker rm -v squid-proxy
docker run -d --name squid-proxy -v /opt/squid/cache:/var/spool/squid3:rw -v /opt/squid/cert:/etc/squid3/ssl_cert:rw -p 3128:3128 bmst/docker-squid-cache-all

