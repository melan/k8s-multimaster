#!/bin/bash

ln -Ffs /vagrant/kubernetes/binaries/kubectl /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/etcd /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/etcdctl /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/flanneld /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/kube-apiserver /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/kube-controller-manager /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/master/kube-scheduler /opt/bin/
