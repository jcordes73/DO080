#!/bin/sh

rm -fr build
mkdir -p build
cp -a ../../apps/jee/* build
cd build
mvn clean install
if [ $? -eq 0 ]; then
  cd ..
  docker build -t todojee .
fi
