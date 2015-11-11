#!/bin/sh

rm -fr build
mkdir -p build
cp -a ../../apps/jee/* build
cd build
mvn clean install
if [ $? -eq 0 ]; then
  cd ..
  docker rmi do080/todojee
  docker build -t do080/todojee .
fi
