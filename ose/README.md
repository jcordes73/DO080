
# Host environment for DO080 Part 2

This Vagrant Box has the minimal setup to build a one-node OSE cluster (to conserve memory only master is used as node). 

## Pre-requisites
These instructions assume you have created the Part 1 environment with Vagrant. See do080/host/README.md.

* Install ansible for your platform
  * For Mac OS X
    * sudo easy_install pip
    * sudo pip install ansible
* Install BIND or otherwise configure DNS
  * On Mac:
    * brew install bind (not as root)
    * cd /usr/local/Cellar/bind/9.10.2/
    * sudo cp *plist /Library/LaunchDaemons
    * sudo mkdir -p /usr/local/opt/bind/sbin/
    * sudo ln -s /usr/local/Cellar/bind/9.10.2/sbin/named /usr/local/opt/bind/sbin
    * determine IP addr of eth1 on the virtual machine
    * FIX ME!!! - instructions for creating wildcard DNS entry to OSE master 

    * sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.bind.plist
    * test: dig ose3-master.example.com (cannot test until vagrant machine is up)
    * ideally test accessing master in a container running on ose3-master:
      * curl -k https://ose3-master.example.com:8443/

## How to build an OpenShift Enterprise master server with Vagrant 
* vagrant up --no-provision --provider virtualbox
* vagrant provision (this takes a LOOOOOONNNNNGGGGG time) 
* scp ../../firewall-cmd.txt ../../firewall-sysconfig.txt ../../install-post.sh vagrant@ose3-master.example.com:~
* vagrant ssh
* sudo su -
* Change the /etc/resolv.conf to point to the host (underlying the VM) for the nameserver (the bind that was installed, e.g. on the Mac with brew)
* cd /home/vagrant
* ./install-post.sh
* oc get pods until the registry and router come online
* vi /etc/openshift/master/master-config.yaml
  * find oauth section
  * change DenyAllPasswordIdentityProvider to HTPasswdPasswordIdentityProvider
  * add a line underneath 'file: /etc/openshift/openshift-passwd'
* vi /etc/openshift/master/master-config.yaml and add, under routingConfig:
  routingConfig:
    subdomain: cloudappsX.example.com
* Restart the openshift-master and openshift-node services
* Test the OSE installation through the creation of an app
  * [as vagrant] oc login -u student -p redhat
  * oc new-project test
  * oc new-app openshift/hello-openshift
  * after the pod is ready:  curl service-ip-addr:8080 - it should say "Hello OpenShift!"

After the original provision of the ose3-master host, and doing a vagrant up, vagrant seems to get confused about which ethX NIC is the one that should be the static IP and changes ETH0.  This causes the vagrant startup cycle to freeze.  You must manually edit the ifcfg-eth0 script using virtualbox and opening a console.  Also, restart the networkmanager.
* Turn off configuration of the private network
  * vi Vagrantfile
  * change master.vm.network :private_network - add auto_config: false
    * This should prevent vagrant from messing with it

* Manually edit the resolv.conf to point to only 192.168.1.1 so that it will use the bind installed on the host and be forwarded to the landrush plugin to find ose3-master.example.com
* Increase the size of the root filesystem
  * In VirtualBox (with vagrant halted) add a second disk drive of 25GB
  * vagrant up
  * partition /dev/sdb for full 25GB
  * pvcreate /dev/sdb1
  * vgextend VolGroup00 /dev/sdb1
  * lvextend /dev/VolGroup00/LogVol00 -l +100%FREE
  * resize2fs /dev/VolGroup00/LogVol00

* Clone the DO080 repository in the student home directory
  * git clone https://github.com/zgutterm/do080
