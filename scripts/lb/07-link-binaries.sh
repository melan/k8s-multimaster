#!/bin/bash

ln -Ffs /vagrant/kubernetes/binaries/kubectl /opt/bin/
# ln -Ffs /vagrant/kubernetes/binaries/master/etcd /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/etcdctl /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/flanneld /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/minion/kubelet /opt/bin/
