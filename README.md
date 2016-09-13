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

