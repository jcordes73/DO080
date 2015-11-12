#!/bin/bash

ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
echo "Using IP: ${ip}"

yum -y update
yum -y install vim-enhanced net-tools iproute git docker deltarpm wget bind-utils python-virtualenv gcc nfs-utils rpcbind

echo "${ip} `hostname`" >> /etc/hosts
#ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
#cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
#chmod 0600 ~/.ssh/authorized_keys 
#ssh-keyscan -H localhost >> ~/.ssh/known_hosts
#ssh-keyscan -H `hostname` >> ~/.ssh/known_hosts
#chmod 0600 ~/.ssh/known_hosts

# Setup Docker image storage (re-do)
rm -f /etc/sysconfig/docker-storage-setup
echo "DOCKER_STORAGE_OPTIONS=" > /etc/sysconfig/docker-storage
lvremove -f VolGroup00/docker-pool
fdisk /dev/sdb <<EOF  || true
n
p



t
8e
w
EOF
partprobe
pvcreate /dev/sdb1
vgcreate docker-vg /dev/sdb1
cat <<'EOF' > /etc/sysconfig/docker-storage-setup
VG=docker-vg
SETUP_LVM_THIN_POOL=yes
EOF
docker-storage-setup
lvextend docker-vg/docker-pool /dev/sdb1
systemctl stop docker
systemctl start docker
systemctl enable docker

# Install NFS
systemctl enable rpcbind
systemctl start rpcbind
systemctl enable nfs-server
systemctl start nfs-server

# Setup for OpenShift Enterprise 3 
#systemctl disable firewalld
#systemctl stop firewalld
#systemctl disable NetworkManager
#systemctl stop NetworkManager

# Install OSE
echo "Run ose-install/installOSE.bash"
