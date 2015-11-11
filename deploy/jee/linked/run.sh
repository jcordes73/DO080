#!/bin/sh 
if [ ! -d "data" ]; then
  echo "Create database volume..."
  sudo mkdir -p /var/local/mysql/data /var/local/mysql/initdb
  sudo chcon -Rt svirt_sandbox_file_t /var/local/mysql/data /var/local/mysql/initdb
  sudo chmod o+rwx /var/local/mysql/data
  sudo cp db.sql /var/local/mysql/initdb 
else
  rm -fr /var/local/mysql/initdb/*
fi

docker run -d --name mysql -e MYSQL_DATABASE=items -e MYSQL_USER=user1 -e MYSQL_PASSWORD=mypa55 -e MYSQL_ROOT_PASSWORD=r00tpa55 -v /var/local/mysql/data:/var/lib/mysql -v /var/local/mysql/initdb:/docker-entrypoint-initdb.d -p 30306:3306 mysql

docker run -d -e MYSQL_DB_NAME=items --link mysql:mysql --name wildfly -p 30080:8080 do080/todojee
