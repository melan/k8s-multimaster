#!/bin/bash

for i in kubelet flanneld kube-proxy docker mesos-slave; do
  [[ $(initctl status $i | grep stop/waiting | wc -l) -gt 0 ]] && initctl start $i

  initctl status $i
done
