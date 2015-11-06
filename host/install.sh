#!/bin/bash

ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
echo "Using IP: ${ip}"

yum -y update
yum -y install vim-enhanced net-tools iproute git docker kubernetes etcd
# Tools to do builds from source code
yum -y install maven java-1.8.0-openjdk-devel
# XXX Ugly hack, does anyone knows a better way?
echo 2 | alternatives --config java
echo 2 | alternatives --config javac

echo "${ip} `hostname`" >> /etc/hosts
ssh-keygen -f /root/.ssh/id_rsa -t rsa -N ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys 
ssh-keyscan -H localhost >> ~/.ssh/known_hosts
ssh-keyscan -H `hostname` >> ~/.ssh/known_hosts
chmod 0600 ~/.ssh/known_hosts

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

# Setup Kubernetes for anonymous access
systemctl disable firewalld
systemctl stop firewalld
sed -i 's/,SecurityContextDeny,ServiceAccount,ResourceQuota"/,SecurityContextDeny,ResourceQuota"/' /etc/kubernetes/apiserver
SERVICES="etcd kube-apiserver kube-controller-manager kube-scheduler"
# Start Kubernetes master
systemctl restart $SERVICES
systemctl enable $SERVICES
# Start Kubernetes minion
SERVICES="kube-proxy kubelet"
systemctl restart $SERVICES
systemctl enable $SERVICES
# No need for flannel because we are using a single host

