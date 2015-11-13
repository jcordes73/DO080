#!/bin/bash

#Changeable variables
ROOT_PASSWORD=redhat
LOG=/var/log/OSEInstall.log

# Change root password to known password
echo redhat | passwd --stdin root

#DO NOT CHANGE THE FOLLOWING VARIABLES (EXCEPT HOST_STATION)
HOST_MASTER=`hostname`
#Deleting resources
rm -rf /root/.ssh/id_rsa* >> /dev/null
rm -rf $LOG


echo "HOST_MASTER=$HOST_MASTER"

#Extract the rpm.tar package
echo "Extracting the rpm.tar package"
tar -xvf rpms.tar >> $LOG

############ Generating ssh-key ###################

#Install sshpass
echo "Installing sshpass"
yum localinstall -y ./rpms/sshpass-1.05-5.el7.x86_64.rpm >> $LOG

#Generate the ssh-key
echo "Generating ssh key"
ssh-keygen -f /root/.ssh/id_rsa -N '' >> $LOG

#Configure SSH
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

#Copying the ssh-key id
sshpass -p $ROOT_PASSWORD ssh-copy-id -i /root/.ssh/id_rsa.pub root@$HOST_MASTER >> $LOG

