#!/bin/bash

cp /opt/kubernetes/current/cluster/ubuntu/master-flannel/init_conf/flanneld.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/etcd.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/kube-apiserver.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/kube-controller-manager.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/kube-scheduler.conf /etc/init/
