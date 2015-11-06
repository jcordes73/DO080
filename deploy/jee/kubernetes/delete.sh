#!/bin/sh

kubectl delete -f wildfly.yaml
kubectl delete -f wildfly-service.yaml
kubectl delete -f mysql.yaml
kubectl delete -f dbclaim.yaml
kubectl delete -f dbinit.yaml
kubectl delete -f pv.yaml
kubectl delete -f mysql-service.yaml

sudo rm -fr /tmp/data01
sudo rm -fr /tmp/initdb
