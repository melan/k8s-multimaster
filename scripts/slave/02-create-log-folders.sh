#!/bin/bash

[[ -d "/vagrant/kubelet/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/kubelet/logs/${HOSTNAME}"
[[ -d "/vagrant/flanneld/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/flanneld/logs/${HOSTNAME}"
