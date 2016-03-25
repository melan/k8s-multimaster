#!/bin/bash

ln -Ffs /vagrant/kubernetes/binaries/kubectl /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/minion/kubelet /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/minion/flanneld /opt/bin/
ln -Ffs /vagrant/kubernetes/binaries/minion/kube-proxy /opt/bin/
