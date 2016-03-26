#!/bin/bash

[[ -d "/vagrant/kubelet/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/kubelet/logs/${HOSTNAME}"
[[ -d "/vagrant/flanneld/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/flanneld/logs/${HOSTNAME}"

[[ -d "/vagrant/zookeeper/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/zookeeper/logs/${HOSTNAME}"
[[ -d "/vagrant/mesos-slave/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/mesos-slave/logs/${HOSTNAME}"
