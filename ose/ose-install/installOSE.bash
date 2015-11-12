#!/bin/bash

#Changeable variables
ROOT_PASSWORD=redhat
LOG=/var/log/OSEInstall.log

# Change root password to known password
echo redhat | passwd --stdin

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


########## Installing ansible ############
echo "Installing ansible"
yum localinstall -y ./rpms/*.rpm >> $LOG



######## Installing OpenShift Enterprise #############
echo "Installing OpenShift Enterprise."

cat <<EOF > /etc/ansible/hosts
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root

# To deploy origin, change deployment_type to origin
deployment_type=enterprise

# enable htpasswd authentication
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/openshift/openshift-passwd'}]

# host group for masters
[masters]
$HOST_MASTER

# host group for nodes
[nodes]
$HOST_MASTER

EOF


#replacing the default router
find ./openshift-ansible -type f -exec sed -i "s/router.default.local/cloudapps.example.com/g" {} +

#installing
ansible-playbook ./openshift-ansible/playbooks/byo/config.yml

#disabling schedulable on master
oadm manage-node $HOST_MASTER --schedulable=true >> $LOG

#adding router

echo \
    '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"router"}}' \
    | oc create -f -

oc get scc privileged -o yaml > scc_privileged.yaml

sed -i '
/users:/ a \
- system:serviceaccount:default:router
' scc_privileged.yaml

oc replace scc privileged -f scc_privileged.yaml

rm -rf scc_privileged.yaml

echo "Creating the router"
oadm router trainingrouter --stats-password='r3dh@t1!' --replicas=1 --config=/etc/openshift/master/admin.kubeconfig --credentials='/etc/openshift/master/openshift-router.kubeconfig' --images='openshift3/ose-${component}:${version}' --service-account=router

#adding registry
echo "Creating the registry"
oadm registry --credentials=/etc/openshift/master/openshift-registry.kubeconfig --images='openshift3/ose-docker-registry'


################# Configuring authentication ##########################
echo "Configuring authentication"
yum install -y httpd-tools >> $LOG
htpasswd -b /etc/openshift/openshift-passwd student redhat >> $LOG


sh ./firewall-cmd.txt
sed -i '/-A FORWARD -j REJECT --reject-with icmp-host-prohibited/r firewall-sysconfig.txt' /etc/sysconfig/iptables
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

oc project default

oc create -f registry-volume.json

oc create -f registry-pvclaim.json

oc volume dc docker-registry --add --overwrite -t persistentVolumeClaim --claim-name=registry-pvclaim --name=registry-storage


#Security for Jenkins Git repo

oc get scc restricted -o json > security.json

sed -i 's/\"MustRunAsRange\"/\"RunAsAny\"/' security.json

oc replace scc restricted -f security.json

rm -rf security.json

