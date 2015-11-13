
# Host environment for DO080

This Vagrant Box has the minimal setup to build a one-node OSE cluster (to conserve memory only master is used as node). 

## Tested under Mac OS X El Capitan

* VirtualBox 5.0.10 
* Vagrant 1.7.4
* vagrant-registration plugin 1.0.0 

## Tested under RHEL7 using:

* `VirtualBox-5.0-5.0.8_103449_el7-1.x86_64`
* `vagrant-1.7.4-1.x86_64`
* `rhel-server-libvirt-7.1-3.x86_64.box`
* CDK 1.0
  * `vagrant-atomic-0.0.3.gem`
  * `vagrant-registration-0.0.8.gem`

## Pre-requisites
* Install VirtualBox 5.x (http://virtualbox.org)
* Install Vagrant 1.7.x (http://vagrantup.com)
* Install vagrant-registration plugin
  * vagrant plugin install vagrant-registration
* Install vagrant-hostmanager plugin
  * vagrant plugin install vagrant-hostmanager
* Add RHEL-7.1.3 vagrant box to your machine
  * download from https://access.redhat.com/downloads/content/293/ver=1/rhel---7/1.0.1/x86_64/product-downloads 
  * vagrant box add --name rhel-7.1.3 ~/Downloads/rhel-server-virtualbox-7.1.3.x86_64.box
* Install ansible for your platform
  * For Mac OS X
    * sudo easy_install pip
    * sudo pip install ansible

## How to install (OBSOLETE -- IGNORE)
* cd do080/ose/ose-install
* tar xfz openshift-ansible.tgz
* cd ..
* vagrant up --provider virtualbox
* enter your registration user id/password for access.redhat.com 
* after full provisioning - vagrant ssh
* sudo su -
* cd /home/vagrant/sync/ose-install
* ./installOSE.bash
* test install - oc get pods - registry/router should be running
  * currently this errors out and I don't know why

## How to install using OSE Vagrant box
* Fix your subscription pool id in env.sh (create one from template)
* . env.sh
* cd do080/ose/ose-install
* tar xzf oo-install-ose.tgz
* tar xzf oo-install-ose-YYMMDD-####.tgz
* cd oo-install-ose-YYMMDD-####
* cd openshift-ansible-$version
* cp do080/ose/Vagrantfile.ansible Vagrantfile
* vagrant up --no-provision --provider virtualbox
* vagrant provision (this takes a LOOOOOONNNNNGGGGG time) 
* cd do080/ose/ose-install
* scp firewall-cmd.txt xxx installOSE-post.bash vagrant@ose3-master.example.com
* vagrant ssh
* sudo su -
* cd /home/vagrant
* ./installOSE-post.bash
* oc get pods until the registry and router come online

