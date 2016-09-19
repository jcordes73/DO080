
# Host environment for DO080, Part One 

The provided virtual machine is compatible with VirtualBox 5.0.x.  The following are instructions for setting up the lab environment.

# DO080 - Course Setup for Part 1

## Lab Environment
This lab environment supports applications deployed using Docker/Kubernetes. This environment was inspired by the course DO276.

* Unarchive and start virtual machine 
  * Using an unarchiver that supports 7z formats (7zip), unzip the archive.
  * Double click on the vbox file or import into VirtualBox and start the VM
* Get the lab files onto the virtual machine  
  * login to the virtual machine using the console
    * userid = student
    * password = redhat
    * that login has sudo privileges without password 
  * git clone https://github.com/zgutterm/do080 (need better place and separate Vagrant files from lab files))
* Speed up builds by pulling down the necessary containers
  * docker pull rhel7.2
  * docker pull mysql
* Determine the IP address for browsing the application
  * ip addr | grep eth1 
  * this allows ssh access in the future instead of the console
* Install MySQL client on the host machine (if desired)
