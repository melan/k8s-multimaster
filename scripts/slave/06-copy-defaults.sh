#!/bin/bash

cp /vagrant/kubelet/defaults-slave /etc/default/kubelet
cp /vagrant/proxy/defaults /etc/default/kube-proxy
cp /vagrant/flanneld/defaults /etc/default/flanneld
cp /vagrant/docker/defaults /etc/default/docker
