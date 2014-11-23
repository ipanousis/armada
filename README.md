Pre-requisites for the control host
=====

* vagrant >= 1.6.5 (https://www.vagrantup.com/downloads.html)
* ansible >= 1.7.0 (http://docs.ansible.com/intro_installation.html)
```
touch ~/.ansible_hosts
echo "export ANSIBLE_HOSTS=~/.ansible_hosts" >> ~/.bashrc
echo "export ANSIBLE_HOST_KEY_CHECKING=False" >> ~/.bashrc
. ~/.bashrc
```
* flocker >= 0.3.2 (find latest version at https://storage.googleapis.com/archive.clusterhq.com)
```
install flocker
$ pip install --quiet https://storage.googleapis.com/archive.clusterhq.com/downloads/flocker/Flocker-0.3.x-py2-none-any.whl
```

FLOCKER CLUSTER SETUP
=====

* vagrant up

* populate ~/.ansible_hosts with the private IPs of the VMs, e.g.
```
[flocker]
172.28.128.3
172.28.128.4
[flocker:vars]
ansible_ssh_user=root
```
* Modify private network interface of cluster in these files, e.g. ansible_enp0s8.ipv4.address for virtualbox:
```
containers/docker_register/docker_register.playbook
containers/hipache/hipache.playbook
```
This network should be the same as the network used in ~/.ansible_hosts.
* Flocker deploy etcd
```
flocker-deploy deployment.yml containers/etcd/fig.yml
```
* Install docker-register on the cluster
```
ansible-playbook containers/docker_register/docker_register.playbook
```
* Add "hipache_redis" to one of the nodes in deployment.yml
* Flocker deploy hipache's redis
```
flocker-deploy deployment.yml containers/hipache_redis/fig.yml
```
* Install hipache on the cluster
```
ansible-playbook containers/hipache/hipache.playbook
```

TODO:

----- TRIGGER THIS WHEN ETCD IS UPDATED BY DOCKER-GEN ------

redis-cli -h flocker.kalamia.in rpush "frontend:etcd.flocker.kalamia.in" "etcd"
redis-cli -h flocker.kalamia.in rpush "frontend:etcd.flocker.kalamia.in" "http://flocker.kalamia.in:4001"

----- TRIGGER THIS WHEN ETCD IS UPDATED BY DOCKER-GEN ------
