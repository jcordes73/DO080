#!/bin/bash

yum -y install wget git net-tools bind-utils iptables-services bridge-utils bash-completion
yum -y update
yum -y install atomic-openshift-utils docker-1.10.3
sed -i '/OPTIONS=.*/c\OPTIONS="--selinux-enabled --insecure-registry 172.30.0.0/16"' \
/etc/sysconfig/docker
systemctl enable docker
systemctl start docker

ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
echo "Using IP: ${ip}"
echo "${ip} `hostname`" >> /etc/hosts
ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys 
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H `hostname` >> ~/.ssh/known_hosts
chmod 0600 ~/.ssh/known_hosts

atomic-openshift-installer -u -c /vagrant/installer.cfg.yml install
