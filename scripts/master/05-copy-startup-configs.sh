#!/bin/bash

HOSTNAME=$(hostname)

cp /opt/kubernetes/current/cluster/ubuntu/master-flannel/init_conf/flanneld.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/etcd.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/kube-apiserver.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/kube-controller-manager.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/master/init_conf/kube-scheduler.conf /etc/init/

cp /vagrant/zookeeper/zookeeper.conf /etc/zookeeper/conf/zoo.cfg
sed -i "s/{{HOSTNAME}}/${HOSTNAME}/" /etc/zookeeper/conf/zoo.cfg

ID=$(hostname | tr -d 'k8s\-master')
grep dataDir /etc/zookeeper/conf/zoo.cfg | cut -d '=' -f 2 | xargs mkdir -p
grep dataDir /etc/zookeeper/conf/zoo.cfg | cut -d '=' -f 2 | xargs chown -R zookeeper:zookeeper
grep dataDir /etc/zookeeper/conf/zoo.cfg | cut -d '=' -f 2 | xargs -I{} /bin/bash -c "echo $ID > {}/myid"

echo "zk://k8s-slave01:2181,k8s-slave02:2181,k8s-slave03:2181/mesos" > /etc/mesos/zk
echo "2" > /etc/mesos-master/quorum

IP=$(ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
echo "${IP}" | tee /etc/mesos-master/ip

rm -f /etc/init/mesos-slave.conf

cat <<EOF > /etc/mesos-cloud.conf
[mesos-cloud]
        mesos-master = zk://k8s-slave01:2181,k8s-slave02:2181,k8s-slave03:2181/mesos
EOF