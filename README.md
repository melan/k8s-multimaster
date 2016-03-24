# k8s-multimaster

A setup to practice on setup of a multimaster Kubernetes environment

> No guarantee that all components will work from the very beginning. Several rounds of restarts maybe needed.

When everything is deployed and `etcd` cluster is up and running - apply:

```
/opt/bin/kubectl --server 172.28.128.3:8080 create -f /vagrant/kubectl/manifests/kube-system.yaml
```

seems this namespace is needed for other components to register in the api.
