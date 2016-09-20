#!/bin/bash

#Changeable variables
ROOT_PASSWORD=redhat
LOG=/var/log/OSEInstall.log


#DO NOT CHANGE THE FOLLOWING VARIABLES (EXCEPT HOST_STATION)
HOST_MASTER=`hostname`


echo "HOST_MASTER=$HOST_MASTER"

#enabling schedulable on master
oadm manage-node $HOST_MASTER --schedulable=true >> $LOG

#adding router

echo "Creating the router"
oadm router trainingrouter --stats-password='r3dh@t1!' --replicas=1 \
     --config=/etc/openshift/master/admin.kubeconfig \
     --credentials='/etc/openshift/master/openshift-router.kubeconfig' \
     --images='openshift3/ose-${component}:${version}' \
     --service-account=router



################# Configuring authentication ##########################
echo "Configuring authentication"
yum install -y httpd-tools >> $LOG
htpasswd -b -c /etc/openshift/openshift-passwd student redhat >> $LOG

################ Configure NFS and mounts ############################
sh /vagrant/firewall-cmd.sh
sed -i '/-A FORWARD -j REJECT --reject-with icmp-host-prohibited/r /vagrant/firewall-sysconfig.txt' /etc/sysconfig/iptables
sed -i 's/RPCMOUNTDOPTS=\"\"/RPCMOUNTDOPTS=\"-p 20048\"/g' /etc/sysconfig/nfs
sed -i 's/STATDARG=\"\"/STATDARG=\"-p 50825\"/g' /etc/sysconfig/nfs
setsebool -P virt_use_nfs=true
systemctl enable rpcbind
systemctl start rpcbind
systemctl enable nfs-server
systemctl start nfs-server

mkdir -p /var/export/registryvol
mkdir -p /var/export/dbvol
chown nfsnobody:nfsnobody /var/export/registryvol
chown nfsnobody:nfsnobody /var/export/dbvol
chmod 700 /var/export/registryvol
chmod 700 /var/export/dbvol
echo "/var/export/registryvol *(rw,async,all_squash)" >> /etc/exports
echo "/var/export/dbvol *(rw,async,all_squash)" >> /etc/exports
exportfs -a

###################### Define Registry with persistence ######################

#adding registry
echo "Creating the registry"

oc project default

oadm registry --service-account=registry \
     --config=/etc/openshift/master/admin.kubeconfig \
     --credentials=/etc/openshift/master/openshift-registry.kubeconfig \
     --images='openshift3/ose-${component}:${version}'

oc volume deploymentconfigs/docker-registry \
   --add --overwrite --name=registry-storage --mount-path=/registry \
   --source='{"nfs": { "server": "ose3-master.example.com", "path": "/var/export/registryvol"}}'
