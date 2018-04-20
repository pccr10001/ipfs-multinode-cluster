#!/bin/bash

node_hash_regex='^peer identity: ([a-zA-Z0-9]{46})'

subnet="172.14.0.0/16"
ips=("172.14.0.2" "172.14.0.3" "172.14.0.4" "172.14.0.5")

image=ipfs

nnodes=${#ips[@]}

pwd=`pwd`

./cleanup.sh 

echo '[1] Configuring for '$nnodes' nodes.'

n=1
for ip in ${ips[*]}
do
    ipfs_dir=ipfs_$n
    mkdir -p $ipfs_dir

    let n++
done

echo '[2] Creating ipfs config'
 
n=1
for ip in ${ips[*]}
do
    ipfs_dir=ipfs_$n

    # Generate the node's hash
    enode=`docker run -v $pwd/$ipfs_dir:/opt/ipfs $image -c /opt/ipfs init`
    while read -r line; do
        [[ "$line" =~ $node_hash_regex ]] && hash="${BASH_REMATCH[1]}"
    done <<< "$enode" 
    echo "[2] + Node $n: $hash init"
    echo "/ip4/$ip/tcp/4001/ipfs/$hash" >> bootstrap_nodes
    let n++
done

echo '[3] Setting up bootstrap nodes'

n=1
for ip in ${ips[*]}
do

    ipfs_dir=ipfs_$n
    # Remove default bootstrap nodes
    docker run -v $pwd/$ipfs_dir:/opt/ipfs $image -c /opt/ipfs bootstrap rm all > /dev/null

    # Add bootstrap nodes
    while read -r line; do
         docker run -v $pwd/$ipfs_dir:/opt/ipfs $image -c /opt/ipfs bootstrap add $line > /dev/null
    done < bootstrap_nodes
    echo "[3] + Node $n configured"
    let n++
done


echo '[4] Creating docker-compose.yml'

cat > docker-compose.yml <<EOF
version: '3'
services:
EOF

n=1
for ip in ${ips[*]}
do
    ipfs_data=ipfs_$n

    cat >> docker-compose.yml <<EOF
  node_$n:
    image: $image
    volumes:
      - './$ipfs_data:/opt/ipfs'
    networks:
      ipfs_net:
        ipv4_address: '$ip'
    ports:
      - $((n+51000)):4001
      - $((n+52000)):5001
      - $((n+53000)):8080
    user: '$uid:$gid'
    command: -c /opt/ipfs daemon
EOF

    let n++
done

cat >> docker-compose.yml <<EOF
networks:
  ipfs_net:
    driver: bridge
    ipam:
      driver: default
      config:
      - subnet: $subnet
EOF

echo '[+] Run `docker-compose up -d` to start ipfs cluster'