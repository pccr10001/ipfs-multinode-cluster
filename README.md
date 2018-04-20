IPFS Private MultiNode Cluster
---

Easily create IPFS private network for testing

# Create container

If you want to select different version of IPFS, just change URL in `docker/Dockerfile`.
```bash=
git clone https://github.com/pccr10001/ipfs-multinode-cluster.git
cd ipfs-multinode-cluster/docker

docker build -t ipfs .
```

# Initial Setup

You can change IPs in `ipfs-init.sh`.
```bash=
cd ipfs-multinode-cluster
./ipfs-init.sh
```

# Run 
```bash=
cd ipfs-multinode-cluster
docker-compose up -d
```