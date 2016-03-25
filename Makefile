

destroy:
	vagrant destroy -f

clean:
	find */logs -type f -delete
	find */logs -type l -delete

	rm -rf etcd/data/k8s-master0?/member/*

recreate: destroy clean
	vagrant up

stop:
	vagrant halt

start:
	vagrant up