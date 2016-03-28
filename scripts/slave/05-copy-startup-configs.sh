#!/bin/bash

# cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kubelet.conf /etc/init/
# cp /opt/kubernetes/current/cluster/ubuntu/minion-flannel/init_conf/flanneld.conf /etc/init/
# cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kube-proxy.conf /etc/init/


rm -f /etc/init/zookeeper.conf
rm -f /etc/init/mesos-master.conf

IP=$(ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)

echo "${IP}" | tee /etc/mesos/ip
echo "zk://172.28.128.101:2181,172.28.128.102:2181,172.28.128.103:2181/mesos" > /etc/mesos/zk
echo "false" > /etc/mesos/hostname_lookup

cat <<CONF >/etc/default/mesos-slave
export MESOS_ZK="zk://172.28.128.101:2181,172.28.128.102:2181,172.28.128.103:2181/mesos"
export MESOS_MASTER="zk://172.28.128.101:2181,172.28.128.102:2181,172.28.128.103:2181/mesos"
export MESOS_IP="${IP}"
export MESOS_HOSTNAME_LOOKUP=false
export MESOS_CONTAINERIZERS="docker,mesos"
export MESOS_WORK_DIR=/var/tmp/mesos
export MESOS_LOG_DIR=/var/log/mesos
export MESOS_ULIMIT="-n 8192"
CONF

cat <<CONF >/etc/init/mesos-slave.conf
description "mesos slave"

# Start just after the System-V jobs (rc) to ensure networking and zookeeper
# are started. This is as simple as possible to ensure compatibility with
# Ubuntu, Debian, CentOS, and RHEL distros. See:
# http://upstart.ubuntu.com/cookbook/#standard-idioms
start on stopped rc RUNLEVEL=[2345]
respawn

script
  [[ ! -f /etc/default/mesos-slave ]] || . /etc/default/mesos-slave
  exec /usr/sbin/mesos-slave
end script
CONF