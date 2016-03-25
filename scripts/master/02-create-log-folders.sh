#!/bin/bash

[[ -d "/vagrant/apiserver/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/apiserver/logs/${HOSTNAME}"
[[ -d "/vagrant/controller/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/controller/logs/${HOSTNAME}"
[[ -d "/vagrant/scheduler/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/scheduler/logs/${HOSTNAME}"
[[ -d "/vagrant/etcd/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/etcd/logs/${HOSTNAME}"
[[ -d "/vagrant/etcd/data/${HOSTNAME}" ]] || mkdir -p "/vagrant/etcd/data/${HOSTNAME}"
[[ -d "/vagrant/flanneld/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/flanneld/logs/${HOSTNAME}"
