
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

## How to install
* cd do080/ose/ose-install
* tar xfz openshift-ansible.tgz
* cd ..
* vagrant up --provider virtualbox
* enter your registration user id/password for access.redhat.com 
* after full provisioning - vagrant ssh
* sudo su -
* cd /home/vagrant/sync/ose/ose-install
* ./installOSE.bash
* test install - oc get pods - registry/router should be running
  * currently this errors out and I don't know why
