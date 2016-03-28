#!/bin/bash

if [[ $(dpkg -l | grep mesos | wc -l) -eq 0 ]]; then
  # Setup
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
  DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
  CODENAME=$(lsb_release -cs)

  # Add the repository
  echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | \
    sudo tee /etc/apt/sources.list.d/mesosphere.list
  sudo apt-get -y update
  sudo apt-get install -y mesos
fi