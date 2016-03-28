#!/bin/bash

for i in zookeeper docker mesos-slave; do
  [[ $(initctl status $i | grep start/running | wc -l) -gt 0 ]] && initctl stop $i

  initctl status $i
done

sleep 10
