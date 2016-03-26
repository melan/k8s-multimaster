#!/bin/bash

cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kubelet.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion-flannel/init_conf/flanneld.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kube-proxy.conf /etc/init/

echo "zk://k8s-slave01:2181,k8s-slave02:2181,k8s-slave03:2181/mesos" > /etc/mesos/zk

rm -f /etc/init/zookeeper.conf
rm -f /etc/init/mesos-master.conf
