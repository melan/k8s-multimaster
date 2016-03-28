#!/bin/bash

HOSTNAME=$(hostname)

cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kubelet.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion-flannel/init_conf/flanneld.conf /etc/init/
cp /opt/kubernetes/current/cluster/ubuntu/minion/init_conf/kube-proxy.conf /etc/init/

cat <<EOF >/etc/default/nginx
events {
  worker_connections  4096;  ## Default: 1024
}

error_log /dev/stdout info;

http {
  access_log /dev/stdout;

  upstream apiservers {
    server 172.28.128.101:8080;
    server 172.28.128.102:8080;
    server 172.28.128.103:8080;
  }

  upstream mesos-masters {
    server 172.28.128.101:5050;
    server 172.28.128.102:5050;
    server 172.28.128.103:5050;
  }

  upstream schedulers {
    server 172.28.128.101:10251;
    server 172.28.128.102:10251;
    server 172.28.128.103:10251;
  }

  upstream etcds {
    server 172.28.128.101:2379;
    server 172.28.128.102:2379;
    server 172.28.128.103:2379;
  }

  server {
    listen 8080;
    location / {
      proxy_pass              http://apiservers;
      proxy_next_upstream     error timeout invalid_header http_500;
      proxy_connect_timeout   2;
      proxy_buffering off;
      proxy_read_timeout 12h;
      proxy_send_timeout 12h;
    }
  }

  server {
    listen 5050;
    location / {
      proxy_pass              http://mesos-masters;
      proxy_next_upstream     error timeout invalid_header http_500;
      proxy_connect_timeout   2;
      proxy_buffering off;
      proxy_read_timeout 12h;
      proxy_send_timeout 12h;
    }
  }

  server {
    listen 2379;
    location / {
      proxy_pass              http://etcds;
      proxy_next_upstream     error timeout invalid_header http_500;
      proxy_connect_timeout   2;
      proxy_buffering off;
      proxy_read_timeout 12h;
      proxy_send_timeout 12h;
    }
  }

  server {
    listen 10251;
    location / {
      proxy_pass              http://schedulers;
      proxy_next_upstream     error timeout invalid_header http_500;
      proxy_connect_timeout   2;
      proxy_buffering off;
      proxy_read_timeout 12h;
      proxy_send_timeout 12h;
    }
  }
}
EOF