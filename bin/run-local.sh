docker kill squid-proxy
docker rm -v squid-proxy
docker run -d --name squid-proxy -v /opt/squid_cache:/var/spool/squid3:rw bmst/docker-squid-cache-all

