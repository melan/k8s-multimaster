#!/bin/bash

cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kubelet.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion-flannel/init_conf/flanneld.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kube-proxy.conf /etc/init/
