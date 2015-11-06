FROM	do080/wildfly

MAINTAINER	Jim Rigsbee <jrigsbee@redhat.com>

ADD	./etc/modules ${JBOSS_HOME}/modules/
ADD	./etc/standalone.conf ${JBOSS_HOME}/bin/
ADD	./etc/wait.sh ${JBOSS_HOME}/bin/
ADD	./etc/standalone.xml  ${JBOSS_HOME}/standalone/configuration/
ADD	./build/target/todo.war ${JBOSS_HOME}/standalone/deployments/
