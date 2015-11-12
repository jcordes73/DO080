#!/bin/bash

iptables -I OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 111 -j ACCEPT
iptables -I OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT
iptables -I OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 20048 -j ACCEPT
iptables -I OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 50825 -j ACCEPT
iptables -I OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 53248 -j ACCEPT

sed -i '/COMMIT/ i \
# BEGIN NFS server \
-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 53248 -j ACCEPT \
-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 50825 -j ACCEPT \
-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 20048 -j ACCEPT \
-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 2049 -j ACCEPT \
-A OS_FIREWALL_ALLOW -p tcp -m state --state NEW -m tcp --dport 111 -j ACCEPT \
# END NFS server' /etc/sysconfig/iptables

# DO NOT restart iptables. Restarting it looses rules added by docker and openshift-sdn

sed -i '
s/RPCMOUNTDOPTS=""/RPCMOUNTDOPTS="-p 20048"/
s/STATDARG=""/STATDARG="-p 50825"/
' /etc/sysconfig/nfs

echo '
fs.nfs.nlm_tcpport=53248
fs.nfs.nlm_udpport=53248
' >> /etc/sysctl.conf

modprobe nfsd
sysctl -p

for u in rpcbind nfs-server nfs-lock nfs-idmap; do
    systemctl enable $u 
    systemctl start $u 
done

setsebool -P virt_use_nfs=true
ssh root@node setsebool -P virt_use_nfs=true

mkdir -p /var/export/dbvol
chown nfsnobody:nfsnobody /var/export/dbvol
chmod 700 /var/export/dbvol
echo "/var/export/dbvol *(rw,async,all_squash)" >> /etc/exports
exportfs -a

