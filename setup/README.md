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

* Install the DO280 classroom on the instructor machine per usual
* TBD
