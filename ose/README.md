
# Host environment for DO080 Part 2

This Vagrant Box has the minimal setup to build a one-node OSE cluster (to conserve memory only master is used as node). 

## Pre-requisites
These instructions assume you have created the Part 1 environment with Vagrant. See do080/host/README.md.

* Install BIND or otherwise configure DNS
  * On Mac:
    * brew install bind (not as root)
    * To have launchd start bind at startup:
      * sudo cp -fv /usr/local/opt/bind/*.plist /Library/LaunchDaemons
      * sudo chown root /Library/LaunchDaemons/homebrew.mxcl.bind.plist
    * To load and unload bind to make configs take effect: 
      * sudo launchctl [unload|load] /Library/LaunchDaemons/homebrew.mxcl.bind.plist
    * IP of ose3-master.example.com is 192.168.1.100 
    * Copy bind config files from the do080/ose/named folder:
      * named.conf -> /usr/local/etc  
        * This assumes you don't have special zone files, if so merge these.
      * db.* -> /usr/local/var/named

    * unload/load bind (see comands above) 
    * add host IP address where bind is running to /etc/resolv.conf as first nameserver entry
    * test: 
      * dig ose3-master.example.com +short
      * dig anything.ose.example.com +short
      * answers should be 192.168.1.100 for both; second dig is a wildcard
    * FIX ME!!! how to get vagrant machine's /etc/resolv.conf pointed to host DNS nameserver

## How to build an OpenShift Enterprise master server with Vagrant 
* vagrant up --no-provision --provider virtualbox
* fix the localhost entry for the hostname in /etc/hosts on vagrant machine:
  * vagrant ssh
  * sudo vi /etc/hosts
  * remove first line for 127.0.0.1 pointing to host name
  * save file
  * exit vagrant machine
* vagrant provision (this takes a LOOOOOONNNNNGGGGG time) 
* vagrant ssh
* sudo su -
* FIXME??Change the /etc/resolv.conf to point to the host (underlying the VM) for the nameserver (the bind that was installed, e.g. on the Mac with brew)
* sh /vagrant/install-post.sh
* watch oc get pods (until the registry and router come online)
* vi /etc/openshift/master/master-config.yaml
  * find oauth section
  * change DenyAllPasswordIdentityProvider to HTPasswdPasswordIdentityProvider
  * add a line underneath 'file: /etc/openshift/openshift-passwd'
* Restart the openshift-master and openshift-node services
* Test the OSE installation through the creation of an app
  * [as vagrant] oc login -u student -p redhat
  * oc new-project test
  * oc new-app openshift/hello-openshift
  * FIX ME?? after the pod is ready:  curl service-ip-addr:8080 - it should say "Hello OpenShift!"

FIX ME?? After the original provision of the ose3-master host, and doing a vagrant up, vagrant seems to get confused about which ethX NIC is the one that should be the static IP and changes ETH0.  This causes the vagrant startup cycle to freeze.  You must manually edit the ifcfg-eth0 script using virtualbox and opening a console.  Also, restart the networkmanager.
* Turn off configuration of the private network
  * vi Vagrantfile
  * change master.vm.network :private_network - add auto_config: false
    * This should prevent vagrant from messing with it

* FIX ME?? Increase the size of the root filesystem
  * In VirtualBox (with vagrant halted) add a second disk drive of 25GB
  * vagrant up
  * partition /dev/sdb for full 25GB
  * pvcreate /dev/sdb1
  * vgextend VolGroup00 /dev/sdb1
  * lvextend /dev/VolGroup00/LogVol00 -l +100%FREE
  * resize2fs /dev/VolGroup00/LogVol00

* Clone the DO080 repository in the student home directory
  * git clone https://github.com/zgutterm/do080
