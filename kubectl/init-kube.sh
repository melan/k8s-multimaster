#!/bin/bash

# define the IP range used for service cluster IPs.
# according to rfc 1918 ref: https://tools.ietf.org/html/rfc1918 choose a private ip range here.
SERVICE_CLUSTER_IP_RANGE=10.10.10.0/24  # formerly PORTAL_NET
# define the IP range used for flannel overlay network, should not conflict with above SERVICE_CLUSTER_IP_RANGE

# Flannel networking is used if CNI networking is not.  The following
# variable defines the CIDR block from which cluster addresses are
# drawn.
FLANNEL_NET=10.100.0.0/16

export KUBERNETES_PROVIDER=ubuntu

while [[ $(/opt/bin/etcdctl cluster-health | grep "cluster is healthy" | wc -l) -eq 0 ]]; do
  echo "ETCD cluster is unhealthy, wait a little"
  sleep 15
done

if [[ $(/opt/bin/etcdctl get /coreos.com/network/config 2>/dev/null | grep "${FLANNEL_NET}" | wc -l) -eq 0 ]]; then
  /opt/bin/etcdctl rm --recursive /coreos.com/network
  /opt/bin/etcdctl set /coreos.com/network/config "{ \"Network\": \"${FLANNEL_NET}\" }"
fi

while [[ $(/opt/bin/kubectl -s 127.0.0.1:8080 get namespace default | grep "Active" | wc -l) -eq 0 ]]; do
  echo "APIServer is not ready yet, wait a little"
  sleep 15
done

if [[ $(/opt/bin/kubectl -s 127.0.0.1:8080 get namespace kube-system | grep "Active" | wc -l) -eq 0 ]]; then
  /opt/bin/kubectl create -f /vagrant/kubectl/manifests/kube-system.yaml
fi


# sleep 60

export SERVICE_CLUSTER_IP_RANGE
export FLANNEL_NET
export PATH=/opt/bin:$PATH

##### Set environment ###############
# And separated with blank space like <user_1@ip_1> <user_2@ip_2> <user_3@ip_3>
export nodes="vagrant@172.28.128.101 vagrant@172.28.128.102 vagrant@172.28.128.103 vagrant@172.28.128.201 vagrant@172.28.128.202 vagrant@172.28.128.203 vagrant@172.28.128.204"

# Define all your nodes role: a(master) or i(minion) or ai(both master and minion), must be the order same
role="a a a i i i i"
# If it practically impossible to set an array as an environment variable
# from a script, so assume variable is a string then convert it to an array
export roles=($role)

# Define minion numbers
export NUM_NODES=4

# Optionally add other contents to the Flannel configuration JSON
# object normally stored in etcd as /coreos.com/network/config.  Use
# JSON syntax suitable for insertion into a JSON object constructor
# after other field name:value pairs.  For example:
# FLANNEL_OTHER_NET_CONFIG=', "SubnetMin": "172.16.10.0", "SubnetMax": "172.16.90.0"'

# Optional: Enable node logging.
# ENABLE_NODE_LOGGING=false
# LOGGING_DESTINATION=${LOGGING_DESTINATION:-elasticsearch}

# Optional: When set to true, Elasticsearch and Kibana will be setup as part of the cluster bring up.
# ENABLE_CLUSTER_LOGGING=false
# ELASTICSEARCH_LOGGING_REPLICAS=${ELASTICSEARCH_LOGGING_REPLICAS:-1}

# Optional: When set to true, heapster, Influxdb and Grafana will be setup as part of the cluster bring up.
# ENABLE_CLUSTER_MONITORING="${KUBE_ENABLE_CLUSTER_MONITORING:-true}"

# Optional: Install cluster DNS.
ENABLE_CLUSTER_DNS="false"

# Optional: Install Kubernetes UI
ENABLE_CLUSTER_UI="false"

# Optional: Enable setting flags for kube-apiserver to turn on behavior in active-dev
#RUNTIME_CONFIG=""

# Optional: Add http or https proxy when download easy-rsa.
# Add envitonment variable separated with blank space like "http_proxy=http://10.x.x.x:8080 https_proxy=https://10.x.x.x:8443"
# PROXY_SETTING=${PROXY_SETTING:-""}

# DEBUG=${DEBUG:-"false"}

#######################################

pushd /opt/kubernetes/current/cluster/ubuntu/
# . deployAddons.sh

/opt/bin/kubectl create -f /vagrant/kubectl/skydns-rc.yaml
/opt/bin/kubectl create -f /vagrant/kubectl/skydns-svc.yaml

/opt/bin/kubectl create -f /vagrant/kubectl/dashboard-controller.yaml
/opt/bin/kubectl create -f /vagrant/kubectl/dashboard-service.yaml