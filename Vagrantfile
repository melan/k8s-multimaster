# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", type: "dhcp"

  ["01", "02", "03"].map { |x| "k8s-master" + x }.each do |hostname| 
    config.vm.define hostname do |host|
      host.vm.hostname = hostname
    end
  end

  config.vm.provision "shell", inline: <<-SHELL
    # apt-get update

    IP=$(ifconfig eth1 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
    
    [[ -d "/vagrant/apiserver/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/apiserver/logs/${HOSTNAME}"
    [[ -d "/vagrant/controller/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/controller/logs/${HOSTNAME}"
    [[ -d "/vagrant/kubelet/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/kubelet/logs/${HOSTNAME}"
    [[ -d "/vagrant/scheduler/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/scheduler/logs/${HOSTNAME}"

    [[ -d "/vagrant/etcd/logs/${HOSTNAME}" ]] || mkdir -p "/vagrant/etcd/logs/${HOSTNAME}"
    [[ -d "/vagrant/etcd/data/${HOSTNAME}" ]] || mkdir -p "/vagrant/etcd/data/${HOSTNAME}"

    if [[ ! -d /opt/etcd ]]; then

      mkdir -p /opt/etcd/{downloads,versions}

      curl -LSs  https://github.com/coreos/etcd/releases/download/v2.3.0/etcd-v2.3.0-linux-amd64.tar.gz -o /opt/etcd/downloads/etcd-v2.3.0-linux-amd64.tar.gz
      cd /opt/etcd/downloads; tar xzvf etcd-v2.3.0-linux-amd64.tar.gz
      mv /opt/etcd/downloads/etcd-v2.3.0-linux-amd64 /opt/etcd/versions/
      ln -s /opt/etcd/versions/etcd-v2.3.0-linux-amd64 /opt/etcd/current

      cp /vagrant/etcd/run_etcd.sh /opt/etcd/
      /opt/etcd/run_etcd.sh &
    fi
    
    killall etcd

    /opt/etcd/current/etcd \
      --data-dir "/vagrant/etcd/data/${HOSTNAME}" \
      --name "${HOSTNAME}" \
      --initial-advertise-peer-urls http://${IP}:2380 \
      --listen-peer-urls http://${IP}:2380 \
      --listen-client-urls http://${IP}:2379,http://127.0.0.1:2379 \
      --advertise-client-urls http://${IP}:2379 \
      --initial-cluster k8s-master01=http://172.28.128.3:2380,k8s-master02=http://172.28.128.4:2380,k8s-master03=http://172.28.128.5:2380 \
      --initial-cluster-state new \
      1>>"/vagrant/etcd/logs/${HOSTNAME}/etcd.log" 2>&1 &

    if [[ ! -d /opt/kubernetes ]]; then
      mkdir -p /opt/kubernetes/{downloads,versions}

      curl -LSs https://github.com/kubernetes/kubernetes/releases/download/v1.2.0/kubernetes.tar.gz -o /opt/kubernetes/downloads/kubernetes-1.2.0.tar.gz
      cd /opt/kubernetes/downloads; tar xf kubernetes-1.2.0.tar.gz
      mv /opt/kubernetes/downloads/kubernetes /opt/kubernetes/versions/kubernetes-1.2.0
      ln -s /opt/kubernetes/versions/kubernetes-1.2.0 /opt/kubernetes/current

      /opt/kubernetes/current/cluster/ubuntu/download-release.sh

      cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kubelet.conf /etc/init/

      mkdir -p /opt/bin
      ln -Ffs /opt/kubernetes/current/cluster/ubuntu/binaries/minion/kubelet /opt/bin/
      ln -Ffs /opt/kubernetes/current/cluster/ubuntu/binaries/kubectl /opt/bin/

      /opt/bin/kubectl create -f /vagrant/kubectl/manifests/kube-system.yaml
    fi

    cp /vagrant/kubelet/defaults /etc/default/kubelet
    if [[ $(which docker | wc -l ) -eq 0 ]]; then
      curl -fsSL https://get.docker.com/gpg | sudo apt-key add -
      curl -fsSL https://get.docker.com/ | sh
      usermod -aG docker vagrant
    fi

    [[ $(ps -ef | grep kubelet | grep -v grep | wc -l) -gt 0 ]] && initctl stop kubelet
    initctl start kubelet

  SHELL
end
