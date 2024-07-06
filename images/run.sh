#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <num> <hostname>"
  exit 1
fi

num=$1
echo $num > /opt/zookeeper/tmp/myid
sed -i "s/^server\.$num=.*/server\.$num=0.0.0.0:2888:3888/" /opt/zookeeper/conf/zoo.cfg

hostname=$2
echo "broker.id=$num" > /opt/kafka/config/server.properties
echo "host.name=$hostname" >> /opt/kafka/config/server.properties
echo "zookeeper.connect=master:2181,slave1:2181,slave2:2181,slave3:2181" >> /opt/kafka/config/server.properties

/usr/bin/ssh-keygen -A
/usr/bin/sshd -D