#!/bin/bash

HOSTNAME=$(hostname)

if [[ -d /etc/kubernetes/manifests ]]; then
  rm -f /etc/kubernetes/manifests/*
else
  mkdir -p /etc/kubernetes/manifests
fi

cp /vagrant/kubelet/manifests-master-src/* /etc/kubernetes/manifests/

# cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/etcd.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kubelet.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion-flannel/init_conf/flanneld.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kube-proxy.conf /etc/init/

mkdir -p /etc/zookeeper/conf
cp /vagrant/zookeeper/zookeeper.conf /etc/zookeeper/conf/zoo.cfg
sed -i "s/{{HOSTNAME}}/${HOSTNAME}/" /etc/zookeeper/conf/zoo.cfg

ID=$(hostname | tr -d 'k8s\-master')
grep dataDir /etc/zookeeper/conf/zoo.cfg | cut -d '=' -f 2 | xargs mkdir -p
grep dataDir /etc/zookeeper/conf/zoo.cfg | cut -d '=' -f 2 | xargs chown -R zookeeper:zookeeper
grep dataDir /etc/zookeeper/conf/zoo.cfg | cut -d '=' -f 2 | xargs -I{} /bin/bash -c "echo \$((10#$ID)) > {}/myid"

mkdir -p /etc/{mesos,mesos-master}

IP=$(ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)

cat <<CONF >/etc/default/mesos-master
export MESOS_ZK="zk://172.28.128.101:2181,172.28.128.102:2181,172.28.128.103:2181/mesos"
export MESOS_QUORUM="2"
export MESOS_IP="${IP}"
export MESOS_HOSTNAME_LOOKUP="false"
export MESOS_PORT="5050"
export MESOS_REGISTRY="in_memory"
export MESOS_WORK_DIR="/var/tmp/mesos"
export MESOS_LOG_DIR="/var/logs/mesos"
export MESOS_ULIMIT="-n 8192"
CONF

rm -f /etc/init/mesos-slave.conf

cat <<EOF > /etc/mesos-cloud.conf
[mesos-cloud]
        mesos-master = zk://172.28.128.101:2181,172.28.128.102:2181,172.28.128.103:2181/mesos
EOF
