#!/bin/sh

set -e

host=$(env | grep MYSQL.*_TCP_ADDR | cut -d = -f 2)
port=$(env | grep MYSQL.*_TCP_PORT | cut -d = -f 2)

echo -n "waiting for TCP connection to $host:$port..."

while ! echo X | nc -w 1 $host $port &>>/dev/null
do
  echo -n .
  sleep 1
done

echo 'ok'
