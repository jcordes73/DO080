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

## Environment 2 (From DO280)

* untar DO280/installers/ose-install.tar.gz
* run installOSE.bash, created by tar, to install OSE and configure master and host
* run DO080/setup/configure-nfs-server.sh to configure NFS on master and host, and to create the NFS share for the database PV
* The todo project has to be on the classroom git server on workstaion or the ucf environment needs internet access to get it from github
  * Copy DO080 to f0 and workstation vm using a usb driver or whatever
  * As root, Create empty remote git repo on on workstation:
    * mkdir /var/www/git/todo.git ; cd /var/www/git/todo.git
    * git init --bare
    * git update-server-info
    * cd .. ; chown -R apache:apache todo.git
  * As student, populate the remote git repo on workstation and replace pom.xml with one suitable for OSE S2I:
    * cd $HOME ; git clone http://workstation.pod0.example.com/todo.git
    * cp -rp DO080/apps/jee/* $HOME/todo ; cd $HOME/todo
    * cp $HOME/DO080/setup/pom.xml .
    * git add . ; git commit -a -m "populating remote repo"
    * git push -u origin master
  * On master copy DO080 contents to have scripts, dockerfiles and json files for demos

[will OSE be able to use just a folder inside the git repo?]


