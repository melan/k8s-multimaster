#!/bin/bash

for i in etcd flanneld kube-apiserver kube-controller-manager kube-scheduler; do
  [[ $(initctl status $i | grep start/running | wc -l) -gt 0 ]] && initctl stop $i

  initctl status $i
done

sleep 10
