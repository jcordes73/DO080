#!/bin/sh 
if [ ! -d "/tmp/data01" ]; then
  echo "Create database volume..."
  mkdir -p /tmp/data01 /tmp/initdb
  chcon -Rt svirt_sandbox_file_t /tmp/data01 /tmp/initdb
  chmod o+rwx /tmp/data01
  cp db.sql /tmp/initdb 
  kubectl create -f pv.yaml
  kubectl create -f dbclaim.yaml
  kubectl create -f dbinit.yaml
else
  rm -fr /tmp/initdb/*
fi

kubectl create -f mysql-service.yaml
kubectl create -f mysql.yaml
kubectl create -f wildfly-service.yaml
kubectl create -f wildfly.yaml
