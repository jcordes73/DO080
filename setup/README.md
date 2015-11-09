# DO080 - Course Setup

## Environment 1 (From DO276)

* Install vagrant and plugins
  * Install vagrant from vagrantup.com
  * Install virtualbox from virtualbox.org
  * vagrant plugin install vagrant-registration
* Clone DO080 repository
  * git clone https://github.com/zgutterm/DO080
* Setup environment script
  * Go to the DO080/host directory
  * Create an env.sh from env.sh.template
  * Customize the parameters based on your RH portal ID and employee subscription pool ID (subscription-manager list --available)
  * Source the script: . env.sh
  * Don't check this file in - there is a .gitignore entry for this file name
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
  * git clone https://github.com/zgutterm/do080
* Speed up builds
  * docker pull rhel7.1
  * docker pull mysql
* Determine the IP address for browsing the application
  * ip addr | grep eth1
* [FL: As the Vagrantfile configures por forward, the application can be acessed using localhost or 127.0.0.1]


## Environment 2 (From DO280)

* untar DO280/installers/ose-install.tar.gz
* run installOSE.bash, created by tar, to install OSE and configure master and host
* Copy the DO080 github repo to f0 and then to master and workstation vms using a usb driver or whatever means available
* run DO080/setup/configure-nfs-server.sh to configure NFS on master and host, and to create the NFS share for the database PV
* The todo project has either to be on the classroom git server on workstation or the ucf environment needs internet access to get it from github
  * As root on workstation (password "redhat"), Create empty remote git repo on on workstation:
    * `mkdir /var/www/git/todo.git ; cd /var/www/git/todo.git`
    * `git init --bare`
    * `git update-server-info`
    * `cd .. ; chown -R apache:apache todo.git`
  * As student on workstation (password "redhat"), populate the remote git repo on workstation and replace pom.xml with one suitable for OSE S2I:
    * `cd $HOME ; git clone http://workstation.pod0.example.com/todo.git`
    * `cp -rp $HOME/DO080/apps/jee/* $HOME/todo ; cd $HOME/todo`
    * `cp $HOME/DO080/setup/pom.xml .`
    * `git add . ; git commit -a -m "populating remote repo"`
    * `git push -u origin master`
  * Remember you'll still need the DO080 gitub repo copy on master to have scripts and json files for ch 5+ demos

Q: will OSE be able to use just a folder inside the git repo?
A: No, app has to be alone as S2I expects pom.xml to be in the root project folder.


