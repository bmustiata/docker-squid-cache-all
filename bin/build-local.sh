
cd $(readlink -f $(dirname $(readlink -f "$0"))/..)
docker build . -t bmst/docker-squid-cache-all

