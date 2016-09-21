
# Host environment for DO080

This Vagrant Box has the minimal setup to build the base container images, the application container images, and test them using either docker links or kubernetes. This environment also provides an OpenShift Enterprise 3.2 installation.

# DO080 - Course Setup

## Lab Environment
This lab environment supports applications deployed using Docker/Kubernetes/OpenShift Enterprise. This environment was inspired by the course DO276/DO280.

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
  * download from https://developers.redhat.com/downloads/
  * vagrant box add --name rhel-7.2 ~/Downloads/rhel-cdk-kubernetes-7.2-29.x86_64.vagrant-virtualbox.box (or whatever the current downloaded file name is)
* Provision virtual environment 
  * vagrant up --provider virtualbox
* Access the virtual environment
  * vagrant ssh
* To stop the environment
  * vagrant halt (leaves the VM intact)
* To destroy the environment
  * vagrant destroy (all work is lost and the VM deleted)

## Finalizing the vagrant box for public use as a non-vagrant environment

* Establish the student account
  * Execute: sh /vagrant/seal.sh
  * Verify no errors occurred
* Use vagrant to Shutdown the VM 
  * Execute: vagrant halt 
  * Note: This performs the very important step of unregistering the subscription
* Zip the VirtualBox VM directory for do080host
  * Recommend using 7zip and separate into 1G files
* Publish files
  * Publish the archive and the PUBLIC-README.md file
