# DO080 - Deploying Containerized Applications Technical Overview

## Contents of Repository

* apps: applications that are deployed in the course
** jee: A To Do List application written as a Java EE 6 app
** sketchpod: A Node.js server app that provides data for hexboard front-end
** hexboard: Front-end web app that works with sketchpod as a back-end
* deploy/jee: Kubernetes files needed to deploy the To Do List app
* host: Vagrant built environment to deploy apps using Docker/Kubernetes
* images/jee: WildFly container image build files used by To Do List app
* ose: Vagrant built environment to deploy apps using OpenShift Enterprise
* setup: instructions to setup Docker and OSE Vagrant machines

## Change History

* September 2016
  * Moved to CDK 2.1 - RHEL 7.2-25 vagrant box
  * Upgraded to Vagrant 1.8.4, VirtualBox 5.0.26
  * Upgraded vagrant-registration plugin to 1.2.1
  * Upgraded vagrant-hostmanager plugin to 1.8.1
  * Renamed part 1 VM to do080host (from atomic)
  * Removed setup folder and moved contents to better folders
  * Changed host/install.sh for proper pool storage construction
  * Provided scripts and instructions for distribution of VM as a lab environment

