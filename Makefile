K8S_VERSION=${K8S_VERSION:-1.2.0}
# REGISTRY=${REGISTRY:-????}

destroy:
	vagrant destroy -f

clean:
	find ./*/logs -type d | grep 'logs$$' | xargs -I{} /bin/bash -c "pushd {}; rm -rf ./*; popd"
	rm -rf etcd/data/*

recreate: destroy clean
	vagrant up

stop:
	vagrant halt

start:
	vagrant up


build_k8s:
