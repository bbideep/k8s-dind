#!/bin/bash

export APISERVER_PORT=8099
export PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

sudo sysctl -w net.ipv4.conf.eth0.route_localnet=1
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
sudo sh -c "echo net.ipv4.ip_forward=1 >> /etc/sysctl.conf"
sudo sysctl -p
sudo sysctl --system
sudo iptables -A FORWARD -i eth0 -o lo -p tcp --syn --dport $APISERVER_PORT -m conntrack --ctstate NEW -j ACCEPT
sudo iptables -A FORWARD -i eth0 -o lo -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -i lo -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -P FORWARD DROP
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport $APISERVER_PORT -j DNAT --to-destination 127.0.0.1
echo $APISERVER_PORT
echo $PRIVATE_IP
sudo iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport $APISERVER_PORT -d 127.0.0.1 -j SNAT --to-source $PRIVATE_IP
