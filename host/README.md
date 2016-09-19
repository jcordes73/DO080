
# Host environment for DO080, Part One 

This Vagrant Box has the minimal setup to build the base container images, the application container images, and test them using either docker links or kubernetes. This environment is based on the course DO276.


# DO080 - Course Setup for Part 1

## Lab Environment
This lab environment supports applications deployed using Docker/Kubernetes. This environment was inspired by the course DO276.

* Install vagrant and plugins
  * Install vagrant from vagrantup.com
  * Install virtualbox from virtualbox.org
  * vagrant plugin install vagrant-registration
* Clone DO080 repository
  * git clone https://github.com/zgutterm/DO080
* Setup environment script
  * Go to the DO080/host directory
  * Copy Vagrantfile.personal to ~/.vagrant.d/Vagrantfile and change the parameters for your Red Hat portal user id, password, and subscription manager pool id (make this file user read only to you if you like) The pool ID (or IDs) can be found with the command: subscription-manager list --available
* Add RHEL-7.2 vagrant box to your machine (from the Red Hat CDK)
  * download from https://access.redhat.com/downloads/content/293/ver=2.1/rhel---7/2.1.0/x86_64/product-software 
  * vagrant box add --name rhel-7.2 ~/Downloads/rhel-cdk-kubernetes-7.2-25.x86_64.vagrant-virtualbox.box (or whatever the current downloaded file name is)
* Provision virtual environment 
  * vagrant up --provider virtualbox
  * this will take as long as 15-20 minutes for the initial provisioning
* Access the virtual environment
  * vagrant ssh
* To stop the environment
  * vagrant halt (leaves the VM intact)
* To destroy the environment
  * vagrant destroy (all work is lost and the VM deleted)

### Preparation for Demos
* Clone the repo on the VM
  * vagrant ssh
  * git clone https://github.com/zgutterm/do080
* Speed up builds by pulling down the necessary containers
  * docker pull rhel7.2
  * docker pull mysql
* Determine the IP address for browsing the application
  * ip addr | grep eth1 (As the Vagrantfile configures port forwarding, the application can be acessed using localhost or 127.0.0.1)
* Install MySQL client on the host machine

## Finalizing the vagrant box for public use as a non-vagrant environment

* Establish the student account
  * Execute: sh /vagrant/seal.sh
  * Verify no errors occurred
* Shutdown the VM from within the VM (don't use vagrant) 
  * Execute: sudo shutdown -h now
* Zip the VirtualBox VM directory for do080host
  * Recommend using 7zip and separate into 1G files
* Publish files
  * Publish the archive and the PUBLIC-README.md file
