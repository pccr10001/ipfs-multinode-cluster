FROM ubuntu:16.04
LABEL MAINTAINER PowerLi<pccr10001@gmail.com>
RUN apt update && \
    apt install -y wget && \
    wget https://dist.ipfs.io/go-ipfs/v0.4.15/go-ipfs_v0.4.15_linux-amd64.tar.gz -O /tmp/go-ipfs.tar.gz && \
    tar xvf /tmp/go-ipfs.tar.gz -C /tmp && \
    mkdir /opt/ipfs && \
    cp /tmp/go-ipfs/ipfs /usr/local/bin/ 
VOLUME ["/opt/ipfs"]
EXPOSE 5001
EXPOSE 4001
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/ipfs"]
