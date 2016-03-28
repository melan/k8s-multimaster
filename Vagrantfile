# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
KUBE_VERSION="1.2.0"

def run_scripts(config, scripts_folder)
  config.vm.provision "shell", inline: <<-SHELL
    export KUBE_VERSION="#{KUBE_VERSION}"
    set -x

    /vagrant/scripts/common/01-install-packages.sh
    /vagrant/scripts/#{scripts_folder}/01-install-packages.sh
    /vagrant/scripts/#{scripts_folder}/02-create-log-folders.sh
    /vagrant/scripts/#{scripts_folder}/03-stop-services.sh
    /vagrant/scripts/common/04-get-latest-kube.sh
    /vagrant/scripts/#{scripts_folder}/05-copy-startup-configs.sh
    /vagrant/scripts/#{scripts_folder}/06-copy-defaults.sh
    /vagrant/scripts/#{scripts_folder}/07-link-binaries.sh
    /vagrant/scripts/#{scripts_folder}/08-start-services.sh
  SHELL
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  lb_instances = ["01"]
  lb_instances.each do |x| 
    hostname = "k8s-lb" + x
    private_id = "172.28.128.7" + x.to_i.to_s

    config.vm.define hostname do |host|
      host.vm.hostname = hostname
      host.vm.network "private_network", ip: private_id

      scripts_folder = "lb"
      run_scripts(host, scripts_folder)
    end
  end


  master_instances = ["01", "02", "03"]

  master_instances.each do |x| 
    hostname = "k8s-master" + x
    private_id = "172.28.128.1" + x

    config.vm.define hostname do |host|
      host.vm.hostname = hostname
      host.vm.network "private_network", ip: private_id

      scripts_folder = "master"
      run_scripts(host, scripts_folder)

      if x == master_instances[0]
        host.vm.provision "shell", inline: <<-SHELL
          mkdir -p "/vagrant/kubectl/logs/${HOSTNAME}"
          /vagrant/kubectl/init-kube.sh >>"/vagrant/kubectl/logs/${HOSTNAME}"/run.log 2>&1 &
        SHELL
      end
    end
  end

  slave_instances = ["01", "02", "03", "04"]
  slave_instances.each do |x| 
    hostname = "k8s-slave" + x
    private_id = "172.28.128.2" + x

    config.vm.define hostname do |host|
      host.vm.hostname = hostname
      host.vm.network "private_network", ip: private_id

      scripts_folder = "slave"
      run_scripts(host, scripts_folder)
    end
  end

  config.vm.provision :hosts, :sync_hosts => true
end
