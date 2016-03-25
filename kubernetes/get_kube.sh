#!/bin/bash

pushd $(dirname $0)

if [[ ! -f ./download-release.sh ]]; then
  curl -LSs https://raw.githubusercontent.com/kubernetes/kubernetes/master/cluster/ubuntu/download-release.sh -o download-release.sh
fi

export FLANNEL_VERSION=${FLANNEL_VERSION:-"0.5.5"}
export ETCD_VERSION=${ETCD_VERSION:-"2.2.1"}
export KUBE_VERSION=${KUBE_VERSION:-"1.2.0"}

. download-release.sh

popd