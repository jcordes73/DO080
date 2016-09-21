#!/bin/bash

ip=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
echo "Using IP: ${ip}"

yum -y update
yum -y install vim-enhanced net-tools iproute git

# Tools to do builds from source code
yum -y install maven java-1.8.0-openjdk-devel
# XXX Ugly hack, does anyone knows a better way?
echo 2 | alternatives --config java
echo 2 | alternatives --config javac

# expand root file system
lvextend -l +100%FREE /dev/VolGroup00/root
xfs_growfs /dev/VolGroup00/root
