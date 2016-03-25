#!/bin/bash

for i in etcd flanneld kube-apiserver kube-controller-manager kube-scheduler; do
  [[ $(initctl status $i | grep stop/waiting | wc -l) -gt 0 ]] && initctl start $i

  initctl status $i
done
