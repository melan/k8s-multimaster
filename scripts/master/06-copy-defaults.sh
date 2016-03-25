#!/bin/bash

cp /vagrant/etcd/defaults /etc/default/etcd
cp /vagrant/apiserver/defaults /etc/default/kube-apiserver
cp /vagrant/controller/defaults /etc/default/kube-controller-manager
cp /vagrant/scheduler/defaults /etc/default/kube-scheduler
cp /vagrant/flanneld/defaults /etc/default/flanneld
