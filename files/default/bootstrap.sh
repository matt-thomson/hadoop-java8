#!/bin/bash

sed s/HOSTNAME/$HOSTNAME/ /etc/hadoop/conf/core-site.xml > /etc/hadoop/conf/core-site.xml

service hadoop-hdfs-namenode start
service hadoop-hdfs-datanode start

service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 == "-bash" ]]; then
  /bin/bash
fi
