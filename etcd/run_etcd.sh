#!/bin/bash

IP=$(ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
LOGFILE="/vagrant/etcd/logs/${HOSTNAME}/etcd.log"

while true ; do
  /opt/etcd/current/etcd \
    --data-dir "/vagrant/etcd/data/${HOSTNAME}" \
    --name "${HOSTNAME}" \
    --initial-advertise-peer-urls http://${IP}:2380 \
    --listen-peer-urls http://${IP}:2380 \
    --listen-client-urls http://${IP}:2379,http://127.0.0.1:2379 \
    --advertise-client-urls http://${IP}:2379 \
    --initial-cluster k8s-master01=http://172.28.128.3:2380,k8s-master02=http://172.28.128.4:2380,k8s-master03=http://172.28.128.5:2380 \
    --initial-cluster-state new \
    1>>${LOGFILE} 2>&1

  echo "ETCD exited with code $?. Waiting a little and restart" >> ${LOGFILE}
  sleep 10
done
