#!/bin/bash

BASEDIR=$(dirname $0)
ALT_KUBE_BUILD_BASE_DIR="${BASEDIR}/downloads/kubernetes"
KUBE_BUILD_BASE_DIR=${KUBE_BUILD_BASE_DIR:-$ALT_KUBE_BUILD_BASE_DIR}

KUBE_VERSION=${KUBE_VERSION:-1.2.0}
ETCD_VERSION=${ETCD_VERSION:-2.2.1}
# REGISTRY
ARCH=${ARCH:-amd64}
BASEIMAGE=${BASEIMAGE:-busybox}

if [ -n "${REGISTRY}" ]; then
  IMAGE_PREFIX="${REGISTRY}/"
else
  IMAGE_PREFIX=""
fi

download() {
  TARGET=${KUBE_BUILD_BASE_DIR}/versions/kubernetes-${KUBE_VERSION}
  [[ -d $TARGET ]] && return

  [[ -d $KUBE_BUILD_BASE_DIR ]] || mkdir -p $KUBE_BUILD_BASE_DIR/{downloads,versions}

  FILE="kubernetes-${KUBE_VERSION}.tar.gz"

  if [[ ! -f "${KUBE_BUILD_BASE_DIR}/downloads/${FILE}" ]]; then
    curl -LSs  https://github.com/kubernetes/kubernetes/releases/download/v${KUBE_VERSION}/kubernetes.tar.gz -o "${KUBE_BUILD_BASE_DIR}/downloads/${FILE}"
  fi

  pushd ${KUBE_BUILD_BASE_DIR}/downloads
  tar xf kubernetes-${KUBE_VERSION}.tar.gz
  popd

  mv ${KUBE_BUILD_BASE_DIR}/downloads/kubernetes $TARGET
}

build_etcd () {
  pushd ${KUBE_BUILD_BASE_DIR}/versions/kubernetes-${KUBE_VERSION}/cluster/images/etcd
  env TAG=$ETCD_VERSION REGISTRY="${REGISTRY}" ARCH=$ARCH BASEIMAGE=$BASEIMAGE make build
  popd
}

build_mesos_km () {
  pushd ${KUBE_BUILD_BASE_DIR}/versions/kubernetes-${KUBE_VERSION}/cluster/mesos/docker/km
  env IMAGE_REPO="${IMAGE_PREFIX}k8s-mesos" IMAGE_TAG="${KUBE_VERSION}" ./build.sh
  popd
}

build_single_node_master() {
  pushd ${KUBE_BUILD_BASE_DIR}/versions/kubernetes-${KUBE_VERSION}

  popd
}

download

build_mesos_km