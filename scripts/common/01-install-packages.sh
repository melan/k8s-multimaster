#!/bin/bash

[[ -d /opt/bin ]] || mkdir -p /opt/bin
echo "KUBE_VERSION=${KUBE_VERSION}"

if [[ ! -d /opt/kubernetes ]]; then
  mkdir -p /opt/kubernetes/{downloads,versions}

  FILE="kubernetes-${KUBE_VERSION}.tar.gz"
  if [[ -f /vagrant/downloads/${FILE} ]]; then
    cp /vagrant/downloads/${FILE} /opt/kubernetes/downloads/
  else
    curl -LSs  https://github.com/kubernetes/kubernetes/releases/download/v${KUBE_VERSION}/kubernetes.tar.gz -o /opt/kubernetes/downloads/${FILE}
    cp /opt/kubernetes/downloads/${FILE} /vagrant/downloads/
  fi
  cd /opt/kubernetes/downloads; tar xf kubernetes-${KUBE_VERSION}.tar.gz
  mv /opt/kubernetes/downloads/kubernetes /opt/kubernetes/versions/kubernetes-${KUBE_VERSION}
  ln -s /opt/kubernetes/versions/kubernetes-${KUBE_VERSION} /opt/kubernetes/current

fi

if [[ $(which docker | wc -l ) -eq 0 ]]; then
  curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
  curl -fsSL https://get.docker.com/ | sh
  usermod -aG docker vagrant
fi

# if [[ $(dpkg -l | grep mesos | wc -l) -eq 0 ]]; then
#   # Setup
#   sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
#   DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
#   CODENAME=$(lsb_release -cs)

#   # Add the repository
#   echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
#     sudo tee /etc/apt/sources.list.d/mesosphere.list
#   sudo apt-get -y update
#   sudo apt-get install -y mesos
# fi